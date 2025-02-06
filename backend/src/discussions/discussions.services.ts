import { InjectModel } from '@nestjs/mongoose';
import mongoose, { Model } from 'mongoose';
import { Discussion } from './discussion.model';

export class DiscussionsService {
  constructor(@InjectModel('Discussion') private readonly discussionModel: Model<Discussion>) {}

  async createOrGetDiscussion(usersIds: string[]) {
    const discussion = await this.discussionModel.findOne({
      users: { $size: usersIds.length, $all: usersIds }
    }).exec();

    if (discussion) {
      return discussion;
    } else {
      if(usersIds.length < 2) {
        throw new Error('Users must be at least 2');
      }
      const newDiscussion = new this.discussionModel({
        chatRoomId: new mongoose.Types.ObjectId().toString(),
        title: '',
        users: usersIds,
        lastMessage: '',
        lastMessageDate: null,
      });
      return await newDiscussion.save();
    }
  }

  async getDiscussions() {
    const discussions = await this.discussionModel.find().exec();
    return discussions.map(discussion => ({
      chatRoomId: discussion.chatRoomId,
      title: discussion.title,
      users: discussion.users,
      lastMessage: discussion.lastMessage,
      lastMessageDate: discussion.lastMessageDate,
    }));
  }
}