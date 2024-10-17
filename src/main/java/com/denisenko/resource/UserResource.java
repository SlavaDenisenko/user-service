package com.denisenko.resource;

import com.denisenko.dto.UserDto;
import com.denisenko.service.UserService;
import jakarta.inject.Inject;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/user")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class UserResource {

    @Inject
    UserService userService;

    @POST
    public UserDto createUser(UserDto userDto) {
        return userService.createUser(userDto);
    }

    @GET
    @Path("/{userId}")
    public UserDto getUser(@PathParam("userId") Integer id) {
        return userService.getUser(id);
    }

    @PUT
    @Path("/{userId}")
    public UserDto updateUser(@PathParam("userId") Integer id, UserDto userDto) {
        return userService.updateUser(id, userDto);
    }

    @DELETE
    @Path("/{userId}")
    public Response deleteUser(@PathParam("userId") Integer id) {
        return userService.deleteUser(id);
    }
}
