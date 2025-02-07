import * as mongoose from 'mongoose';

export const DiscussionSchema = new mongoose.Schema({
  title: { type: String, required: false },
  users: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  lastMessage: { type: String, required: false },
  lastMessageDate: { type: Date, required: false },
});

export interface Discussion extends mongoose.Document {
  id: string;
  title: string;
  users: string[];
  lastMessage: string;
  lastMessageDate: Date;
}