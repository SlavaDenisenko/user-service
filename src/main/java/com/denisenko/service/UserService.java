package com.denisenko.service;

import com.denisenko.dto.UserDto;
import com.denisenko.entity.User;
import com.denisenko.mapper.UserMapper;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.persistence.PersistenceException;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.NotFoundException;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;

import java.util.Optional;

@ApplicationScoped
public class UserService {

    @Inject
    UserMapper userMapper;

    @Transactional
    public UserDto createUser(UserDto userDto) {
        User user = userMapper.toEntity(userDto);
        user.persist();

        if (user.isPersistent()) {
            Optional<User> optionalUser = User.findByIdOptional(user.getId());
            user = optionalUser.orElseThrow(NotFoundException::new);
            return userMapper.toDto(user);
        } else {
            throw new PersistenceException();
        }
    }

    public UserDto getUser(Integer id) {
        return userMapper.toDto(User.findById(id));
    }

    @Transactional
    public UserDto updateUser(Integer id, UserDto userDto) {
        User user = User.findById(id);
        if (user == null)
            throw new WebApplicationException("User with ID=" + id + " does not exist.", 404);

        userMapper.updateEntityFromDto(userDto, user);
        user.setId(id);
        user.persist();
        return userMapper.toDto(user);
    }

    @Transactional
    public Response deleteUser(Integer id) {
        boolean isDeleted = User.deleteById(id);

        if (!isDeleted)
            throw new WebApplicationException("User with ID=" + id + " does not exist.", 404);

        return Response.status(204).build();
    }
}
