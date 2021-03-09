package io.dataease.service.sys;

import io.dataease.base.domain.SysUser;
import io.dataease.base.domain.SysUserExample;
import io.dataease.base.domain.SysUsersRolesExample;
import io.dataease.base.domain.SysUsersRolesKey;
import io.dataease.base.mapper.SysUserMapper;
import io.dataease.base.mapper.SysUsersRolesMapper;
import io.dataease.base.mapper.ext.ExtSysUserMapper;
import io.dataease.commons.utils.BeanUtils;
import io.dataease.commons.utils.CodingUtil;
import io.dataease.controller.sys.request.SysUserCreateRequest;
import io.dataease.controller.sys.request.SysUserPwdRequest;
import io.dataease.controller.sys.request.SysUserStateRequest;
import io.dataease.controller.sys.request.UserGridRequest;
import io.dataease.controller.sys.response.SysUserGridResponse;
import io.dataease.controller.sys.response.SysUserRole;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SysUserService {

    private final static String USER_CACHE_NAME = "users_info";
    private final static String DEFAULT_PWD = "DataEase123..";

    @Resource
    private SysUserMapper sysUserMapper;

    @Resource
    private SysUsersRolesMapper sysUsersRolesMapper;

    @Resource
    private ExtSysUserMapper extSysUserMapper;

    public List<SysUserGridResponse> query(UserGridRequest request){
        List<SysUserGridResponse> lists = extSysUserMapper.query(request);
        lists.forEach(item -> {
            List<SysUserRole> roles = item.getRoles();
            List<Long> roleIds = roles.stream().map(SysUserRole::getRoleId).collect(Collectors.toList());
            item.setRoleIds(roleIds);
        });
        return lists;
    }

    @Transactional
    public int save(SysUserCreateRequest request){
        SysUser user = BeanUtils.copyBean(new SysUser(), request);
        long now = System.currentTimeMillis();
        user.setCreateTime(now);
        user.setUpdateTime(now);
        user.setIsAdmin(false);
        if (ObjectUtils.isEmpty(user.getPassword()) || StringUtils.equals(user.getPassword(), DEFAULT_PWD)){
            user.setPassword(CodingUtil.md5(DEFAULT_PWD));
        }else{
            user.setPassword(CodingUtil.md5(user.getPassword()));
        }
        int insert = sysUserMapper.insert(user);
        SysUser dbUser = findOne(user);
        saveUserRoles(dbUser.getUserId(), request.getRoleIds());//插入用户角色关联
        return insert;
    }

    @Transactional
    public int update(SysUserCreateRequest request){
        SysUser user = BeanUtils.copyBean(new SysUser(), request);
        long now = System.currentTimeMillis();
        user.setUpdateTime(now);
        deleteUserRoles(user.getUserId());//先删除用户角色关联
        saveUserRoles(user.getUserId(), request.getRoleIds());//再插入角色关联
        return sysUserMapper.updateByPrimaryKey(user);
    }


    public int updateStatus(SysUserStateRequest request){
        SysUser sysUser = new SysUser();
        sysUser.setUserId(request.getUserId());
        sysUser.setEnabled(request.getEnabled());
        return sysUserMapper.updateByPrimaryKeySelective(sysUser);
    }

    /**
     * 修改用户密码清楚缓存
     * @param request
     * @return
     */
    @CacheEvict(value = USER_CACHE_NAME, key = "'user' + #request.userId")
    public int updatePwd(SysUserPwdRequest request) {
        if (!StringUtils.equals(request.getPassword(), request.getRepeatPassword())){
            throw new RuntimeException("两次密码不一致");
        }
        SysUser temp = new SysUser();
        temp.setUserId(request.getUserId());
        SysUser user = findOne(temp);
        if (ObjectUtils.isEmpty(user)) {
            throw new RuntimeException("用户不存在");
        }
        if (!StringUtils.equals(request.getPassword(), user.getPassword())){
            throw new RuntimeException("密码错误");
        }
        SysUser sysUser = new SysUser();
        sysUser.setUserId(request.getUserId());
        sysUser.setPassword(CodingUtil.md5(request.getNewPassword()));
        return sysUserMapper.updateByPrimaryKeySelective(sysUser);
    }



    /**
     * 删除用户角色关联
     * @param userId
     * @return
     */
    private int deleteUserRoles(Long userId){
        SysUsersRolesExample example = new SysUsersRolesExample();
        example.createCriteria().andUserIdEqualTo(userId);
        return sysUsersRolesMapper.deleteByExample(example);
    }

    /**
     * 保存用户角色关联
     * @param userId
     * @param roleIds
     */
    private void saveUserRoles(Long userId, List<Long> roleIds){
        roleIds.forEach(roleId -> {
            SysUsersRolesKey sysUsersRolesKey = new SysUsersRolesKey();
            sysUsersRolesKey.setUserId(userId);
            sysUsersRolesKey.setRoleId(roleId);
            sysUsersRolesMapper.insert(sysUsersRolesKey);
        });
    }

    @CacheEvict(value = USER_CACHE_NAME, key = "'user' + #userId")
    @Transactional
    public int delete(Long userId){
        deleteUserRoles(userId);
        return sysUserMapper.deleteByPrimaryKey(userId);
    }

    public SysUser findOne(SysUser user){
        if (ObjectUtils.isEmpty(user)) return null;
        if (ObjectUtils.isNotEmpty(user.getUserId())){
            return sysUserMapper.selectByPrimaryKey(user.getUserId());
        }
        SysUserExample example = new SysUserExample();
        SysUserExample.Criteria criteria = example.createCriteria();
        if (ObjectUtils.isNotEmpty(user.getUsername())){
            criteria.andUsernameEqualTo(user.getUsername());
            List<SysUser> sysUsers = sysUserMapper.selectByExample(example);
            if (CollectionUtils.isNotEmpty(sysUsers))return sysUsers.get(0);
        }
        return null;
    }


    public List<SysUser> users(List<Long> userIds){
        return userIds.stream().map(sysUserMapper::selectByPrimaryKey).collect(Collectors.toList());
    }

}