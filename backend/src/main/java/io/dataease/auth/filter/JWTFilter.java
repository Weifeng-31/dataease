package io.dataease.auth.filter;

import io.dataease.auth.entity.JWTToken;
import io.dataease.auth.entity.SysUserEntity;
import io.dataease.auth.entity.TokenInfo;
import io.dataease.auth.service.AuthUserService;
import io.dataease.auth.util.JWTUtils;
import io.dataease.commons.utils.CommonBeanFactory;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.BasicHttpAuthenticationFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestMethod;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class JWTFilter extends BasicHttpAuthenticationFilter {


    private Logger LOGGER = LoggerFactory.getLogger(this.getClass());

    /*@Autowired
    private AuthUserService authUserService;*/


    /**
     * 判断用户是否想要登入。
     * 检测header里面是否包含Authorization字段即可
     */
    @Override
    protected boolean isLoginAttempt(ServletRequest request, ServletResponse response) {
        HttpServletRequest req = (HttpServletRequest) request;
        String authorization = req.getHeader("Authorization");
        return authorization != null;
    }

    /**
     *
     */
    @Override
    protected boolean executeLogin(ServletRequest request, ServletResponse response) throws Exception {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        String authorization = httpServletRequest.getHeader("Authorization");

        if (JWTUtils.needRefresh(authorization)){
            authorization = refreshToken(request, response);
        }
        JWTToken token = new JWTToken(authorization);
        Subject subject = getSubject(request, response);
        // 提交给realm进行登入，如果错误他会抛出异常并被捕获
        subject.login(token);
        return true;
    }



    /**
     */
    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
        if (isLoginAttempt(request, response)) {
            try {
                boolean loginSuccess = executeLogin(request, response);
                return loginSuccess;
            } catch (Exception e) {
                response401(request, response);
            }
        }
        return false;
    }

    private String refreshToken(ServletRequest request, ServletResponse response) throws Exception{
        // 获取AccessToken(Shiro中getAuthzHeader方法已经实现)
        String token = this.getAuthzHeader(request);
        // 获取当前Token的帐号信息
        TokenInfo tokenInfo = JWTUtils.tokenInfoByToken(token);
        AuthUserService authUserService = CommonBeanFactory.getBean(AuthUserService.class);
        SysUserEntity user = authUserService.getUserById(tokenInfo.getUserId());
        String password = user.getPassword();
        String newToken = JWTUtils.sign(tokenInfo, password);
        JWTToken jwtToken = new JWTToken(newToken);
        this.getSubject(request, response).login(jwtToken);
        // 设置响应的Header头新Token
        HttpServletResponse httpServletResponse = (HttpServletResponse) response;
        httpServletResponse.addHeader("Access-Control-Expose-Headers", "RefreshAuthorization");
        httpServletResponse.setHeader("RefreshAuthorization", newToken);
        return newToken;
    }


    /**
     * 对跨域提供支持
     */
    @Override
    protected boolean preHandle(ServletRequest request, ServletResponse response) throws Exception {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        HttpServletResponse httpServletResponse = (HttpServletResponse) response;
        httpServletResponse.setHeader("Access-control-Allow-Origin", httpServletRequest.getHeader("Origin"));
        httpServletResponse.setHeader("Access-Control-Allow-Methods", "GET,POST,OPTIONS,PUT,DELETE");
        httpServletResponse.setHeader("Access-Control-Allow-Headers", httpServletRequest.getHeader("Access-Control-Request-Headers"));
        // 跨域时会首先发送一个option请求，这里我们给option请求直接返回正常状态
        if (httpServletRequest.getMethod().equals(RequestMethod.OPTIONS.name())) {
            httpServletResponse.setStatus(HttpStatus.OK.value());
            return false;
        }
        return super.preHandle(request, response);
    }

    /**
     * 将非法请求跳转到 /401
     */
    private void response401(ServletRequest req, ServletResponse resp) {
        try {
            HttpServletResponse httpServletResponse = (HttpServletResponse) resp;
            httpServletResponse.addHeader("Access-Control-Expose-Headers", "authentication-status");
            httpServletResponse.setHeader("authentication-status", "invalid");
            httpServletResponse.setStatus(401);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
        }
    }
}