import * as mongoose from 'mongoose';

export const DiscussionSchema = new mongoose.Schema({
  chatRoomId: { type: String, required: true },
  users: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  lastMessage: { type: String, required: false },
  lastMessageDate: { type: Date, required: false },
});

export interface Discussion extends mongoose.Document {
  id: string;
  chatRoomId: string;
  users: string[];
  lastMessage: string;
  lastMessageDate: Date;
}