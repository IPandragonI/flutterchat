import { InjectModel } from '@nestjs/mongoose';
import mongoose, { Model } from 'mongoose';
import { Message } from './message.model';
import { UsersService } from '../users/users.service';


export class MessagesService {
  constructor(
    @InjectModel('Message') private readonly messageModel: Model<Message>,
    private readonly usersService: UsersService,
  ) {
  }

  async insertMessage(discussionId: string, content: string, sender: string) {
    const newMessage = new this.messageModel({
      discussionId,
      content,
      sender,
      date: new Date(),
      seenBy: [],
    });
    const result = await newMessage.save();
    return result.id as string;
  }

  async getAllMessagesFromDiscussion(discussionId: string) {
    const messages = await this.messageModel.find({ discussionId }).exec();
    return await Promise.all(messages.map(async (message) => {
      const sender = this.usersService.getUserById(message.sender);
      const seenBy = this.usersService.getUsersByIds(message.seenBy);
      return {
        id: message.id,
        discussionId: message.discussionId,
        content: message.content,
        sender: sender,
        date: message.date,
        seenBy: seenBy,
      };
    }));
  }
}