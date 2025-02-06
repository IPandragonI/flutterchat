import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import { User } from './user.model';

export class UsersServices {
  constructor(@InjectModel('User') private readonly userModel: Model<User>) {
  }

  async insertUser(firstName: string, lastName: string, email: string, password: string, profilePicture: string) {
    const newUser = new this.userModel({
      firstName,
      lastName,
      email,
      password,
      profilePicture,
    });
    const result = await newUser.save();
    return result.id as string;
  }

  async getUsers() {
    const users = await this.userModel.find().exec();
    return users.map(user => ({
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      profilePicture: user.profilePicture,
    }));
  }

  async getUsersWithoutEmail(email: string) {
    const users = await this.userModel.find({ email: { $ne: email } }).exec();
    return users.map(user => ({
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      profilePicture: user.profilePicture,
    }));
  }

  async getUser(email: string) {
    const user = await this.userModel.findOne({ email });
    return {
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
      profilePicture: user.profilePicture,
    };
  }

  async checkUserAlreadyExists(email: string) {
    const user = await this.userModel.findOne({ email });
    return !!user;
  }
}