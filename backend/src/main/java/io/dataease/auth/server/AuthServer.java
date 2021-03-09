package io.dataease.auth.server;

import io.dataease.auth.api.AuthApi;
import io.dataease.auth.api.dto.CurrentRoleDto;
import io.dataease.auth.api.dto.CurrentUserDto;
import io.dataease.auth.api.dto.LoginDto;
import io.dataease.auth.config.RsaProperties;
import io.dataease.auth.entity.SysUserEntity;
import io.dataease.auth.entity.TokenInfo;
import io.dataease.auth.service.AuthUserService;
import io.dataease.auth.util.JWTUtils;
import io.dataease.auth.util.RsaUtil;
import io.dataease.commons.utils.BeanUtils;
import io.dataease.commons.utils.CodingUtil;
import io.dataease.commons.utils.ServletUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class AuthServer implements AuthApi {

    @Autowired
    private AuthUserService authUserService;


    @Override
    public Object login(@RequestBody LoginDto loginDto) throws Exception {
        String username = loginDto.getUsername();
        String password = loginDto.getPassword();
        SysUserEntity user = authUserService.getUserByName(username);
        String realPwd = user.getPassword();
        if (ObjectUtils.isEmpty(user)){
            throw new RuntimeException("没有该用户！");
        }
        //私钥解密
        String pwd = RsaUtil.decryptByPrivateKey(RsaProperties.privateKey, password);
        //md5加密
        pwd = CodingUtil.md5(pwd);

        if (!StringUtils.equals(pwd, realPwd)){
            throw new RuntimeException("密码错误！");
        }
        Map<String,Object> result = new HashMap<>();
        TokenInfo tokenInfo = TokenInfo.builder().userId(user.getUserId()).username(username).lastLoginTime(System.currentTimeMillis()).build();
        String token = JWTUtils.sign(tokenInfo, realPwd);
        result.put("token", token);
        ServletUtils.setToken(token);
        return result;
    }

    @Override
    public CurrentUserDto userInfo() {
        String token = ServletUtils.getToken();
        Long userId = JWTUtils.tokenInfoByToken(token).getUserId();
        SysUserEntity user = authUserService.getUserById(userId);
        CurrentUserDto currentUserDto = BeanUtils.copyBean(new CurrentUserDto(), user);
        List<CurrentRoleDto> currentRoleDtos = authUserService.roleInfos(user.getUserId());
        List<String> permissions = authUserService.permissions(user.getUserId());
        currentUserDto.setRoles(currentRoleDtos);
        currentUserDto.setPermissions(permissions);
        return currentUserDto;
    }

    @Override
    public String logout(){
        return "success";
    }

    @Override
    public Boolean isLogin() {
        return null;
    }

    @Override
    public String test() {
        return "apple";
    }
}