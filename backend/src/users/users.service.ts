import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import { User } from './user.model';

export class UsersService {
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
    return await this.userModel.find().exec();
  }

  async getUsersWithoutEmail(email: string) {
    return await this.userModel.find({ email: { $ne: email } }).exec();
  }

  async getUserById(userId: string) {
    return await this.userModel.findById(userId).exec();
  }

  async getUser(email: string) {
    return await this.userModel.findOne({ email }).exec();
  }

  async getUsersByIds(userIds: string[]) {
    return await this.userModel.find({ _id: { $in: userIds } }).exec();
  }

  async checkUserAlreadyExists(email: string) {
    const user = await this.userModel.findOne({ email });
    return !!user;
  }
}