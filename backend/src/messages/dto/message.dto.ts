import { IsNotEmpty, IsString, MinLength } from 'class-validator';

export class MessageDto {
  @IsString()
  @IsNotEmpty()
  discussionId: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(1)
  content: string;

  @IsString()
  @IsNotEmpty()
  sender: string;
}