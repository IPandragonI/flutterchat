import { InjectModel } from '@nestjs/mongoose';
import mongoose, { Model } from 'mongoose';
import { Message } from './message.model';
import { UsersService } from '../users/users.service';
import { MessageDto } from './dto/message.dto';


export class MessagesService {
  constructor(
    @InjectModel('Message') private readonly messageModel: Model<Message>,
    private readonly usersService: UsersService,
  ) {
  }

  async insertMessage(messageDto: MessageDto) {
    const { discussionId, content, sender } = messageDto;
    const newMessage = new this.messageModel({
      discussionId,
      content,
      sender,
      date: new Date(),
      seenBy: [],
    });
    const savedMessage = await newMessage.save();
    const senderDetails = await this.usersService.getUserById(savedMessage.sender);
    return {
      ...savedMessage.toObject(),
      sender: senderDetails,
    };
  }

  async getAllMessagesFromDiscussion(discussionId: string) {
    const messages = await this.messageModel.find({ discussionId }).exec();
    return await Promise.all(messages.map(async (message) => {
      const sender = await this.usersService.getUserById(message.sender);
      const seenBy = await this.usersService.getUsersByIds(message.seenBy);
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