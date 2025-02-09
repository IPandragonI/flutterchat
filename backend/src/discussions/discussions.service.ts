import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Discussion } from './discussion.model';
import { UsersService } from '../users/users.service';

export class DiscussionsService {
  constructor(
    @InjectModel('Discussion') private readonly discussionModel: Model<Discussion>,
    private readonly usersService: UsersService,
  ) {
  }


  async createOrGetDiscussion(usersIds: string[]) {
    const discussion = await this.discussionModel.findOne({
      users: { $size: usersIds.length, $all: usersIds },
    }).exec();

    if (discussion) {
      const users = await this.usersService.getUsersByIds(discussion.users);
      return {
        id: discussion.id,
        title: discussion.title,
        users: users,
        lastMessage: discussion.lastMessage,
        lastMessageDate: discussion.lastMessageDate,
      };
    } else {
      if (usersIds.length < 2) {
        throw new Error('Users must be at least 2');
      }
      const newDiscussion = new this.discussionModel({
        title: '',
        users: usersIds,
        lastMessage: '',
        lastMessageDate: null,
      });
      return await newDiscussion.save();
    }
  }

  async getDiscussionsOfUser(userId: string) {
    const discussions = await this.discussionModel.find({ users: userId }).exec();
    return await Promise.all(discussions.map(async (discussion) => {
      const users = await this.usersService.getUsersByIds(discussion.users);
      return {
        id: discussion.id,
        title: discussion.title,
        users: users,
        lastMessage: discussion.lastMessage,
        lastMessageDate: discussion.lastMessageDate,
      };
    }));
  }

  async getDiscussions() {
    return await this.discussionModel.find().exec();
  }
}