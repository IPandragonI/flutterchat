import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';

import { Discussion } from './discussion.model';

export class DiscussionsService {
  constructor(@InjectModel('Discussion') private readonly discussionModel: Model<Discussion>) {
  }

  async createOrGetDiscussion(users: string[]) {
    const discussion = await this.discussionModel.findOne({ users }).exec();
    if (discussion) {
      return discussion.chatRoomId;
    } else {
      const newDiscussion = new this.discussionModel({
        users,
        lastMessage: '',
        lastMessageDate: new Date(),
      });
      const result = await newDiscussion.save();
      return result.chatRoomId;
    }
  }

  async getDiscussions() {
    const discussions = await this.discussionModel.find().exec();
    return discussions.map(discussion => ({
      chatRoomId: discussion.chatRoomId,
      users: discussion.users,
      lastMessage: discussion.lastMessage,
      lastMessageDate: discussion.lastMessageDate,
    }));
  }
}