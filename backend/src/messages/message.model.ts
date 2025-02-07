import * as mongoose from 'mongoose';

export const MessageSchema = new mongoose.Schema({
  chatRoomId: { type: String, required: true },
  content: { type: String, required: true },
  sender: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  date: { type: Date, required: true },
  seenBy: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
});

export interface Message extends mongoose.Document {
  id: string;
  chatRoomId: string;
  content: string;
  sender: string;
  date: Date;
  seenBy: string[];
}