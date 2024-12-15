import { Body, Controller, Get, Post } from '@nestjs/common';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  async getAllUsers() {
    return await this.usersService.getUsers();
  }

  @Post()
  async addUser(
    @Body('firstName') firstName: string,
    @Body('lastName') lastName: string,
    @Body('email') email: string,
    @Body('password') password: string,
    @Body('profilePicture') profilePicture: string,
  ) {
    const generatedId = await this.usersService.insertUser(
      firstName,
      lastName,
      email,
      password,
      profilePicture,
    );
    return { id: generatedId };
  }
}