class CommentRepliesController < ApplicationController
  before_action :set_comment, only: %i[index new cancel_new create search cancel_search unread cancel_unread]
  before_action :set_comment_reply, only: %i[edit update destroy cancel_edit delete_comment_reply_image]

  def index
    @q = @comment.comment_replies.ransack(params[:q])
    @comment_replies = @q.result(distinct: true).includes(:user).with_attached_comment_reply_image.order(created_at: :asc)
  end

  def reply_to_parent
    parent = CommentReply.find(params[:id])
    comment = parent.comment
    session[:parent] = parent
    redirect_to new_comment_comment_reply_path(comment)
  end

  def new
    @comment_reply = CommentReply.new
    if session[:parent]
      parent_hash = session[:parent]
      @parent = CommentReply.find(parent_hash["id"])
      session.delete(:parent)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("comment_reply_change_form", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent }) }
        format.html {  }
      end
    else
      @parent_nil = nil
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("comment_reply_change_form", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent_nil }) }
        format.html {  }
      end
    end
  end

  def cancel_new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_reply_change_form", partial: "comment_replies/comment_reply_button_part", locals: { comment: @comment }) }
      format.html {  }
    end
  end

  def create
    @comment_reply = current_user.comment_replies.build(comment_reply_params)
    if @comment_reply.save
      @comment_reply.broadcast_append_to("comment_replies_list", target: "comment_replies_comment_#{@comment.id}", partial: "comment_replies/comment_reply_frame", locals: { comment_reply: @comment_reply })
      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t("defaults.message.created", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.update("comment_reply_change_form", partial: "comment_replies/comment_reply_button_part", locals: { comment: @comment }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    elsif @comment_reply.parent_id.present?
      @parent = CommentReply.find(@comment_reply.parent_id)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_created", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.update("comment_reply_change_form", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    else
      @parent_nil = nil
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_created", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.update("comment_reply_change_form", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent_nil }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    end
  end

  def show
    @comment_reply = CommentReply.find(params[:id])
    @comment = @comment_reply.comment
    if request.headers["turbo-frame"]
      render partial: "comment_replies/comment_reply", locals: { comment_reply: @comment_reply }
    else
      redirect_to comment_comment_replies_path(@comment)
    end
  end

  def edit
    @comment = @comment_reply.comment
    if @comment_reply.parent_id.present?
      @parent = CommentReply.find(@comment_reply.parent_id)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("edit_form_comment_reply_#{@comment_reply.id}", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent })
          ]
        end
        format.html {  }
      end
    else
      @parent_nil = nil
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("edit_form_comment_reply_#{@comment_reply.id}", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent_nil })
          ]
        end
        format.html {  }
      end
    end
  end

  def cancel_edit
    @comment = @comment_reply.comment
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("comment_reply_#{@comment_reply.id}", partial: "comment_reply", locals: { comment_reply: @comment_reply })
        ]
      end
      format.html {  }
    end
  end

  def delete_comment_reply_image
    @comment_reply.comment_reply_image.purge
    @comment = @comment_reply.comment
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("form_comment_reply_#{@comment_reply.id}", partial: "form_part", locals: { comment: @comment, comment_reply: @comment_reply }) }
      format.html {  }
    end
  end

  def update
    @comment = @comment_reply.comment
    if @comment_reply.update(comment_reply_update_params)
      @comment_reply.broadcast_replace_to("comment_replies_list", target: "comment_reply_#{@comment_reply.id}", partial: "comment_replies/comment_reply_frame", locals: { comment_reply: @comment_reply })
      respond_to do |format|
        format.turbo_stream do
          flash.now[:success] = t("defaults.message.updated", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    elsif @comment_reply.parent_id.present?
      @parent = CommentReply.find(@comment_reply.parent_id)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_updated", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.update("edit_form_comment_reply_#{@comment_reply.id}", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    else
      @parent_nil = nil
      respond_to do |format|
        format.turbo_stream do
          flash.now[:danger] = t("defaults.message.not_updated", item: CommentReply.model_name.human)
          render turbo_stream: [
            turbo_stream.update("edit_form_comment_reply_#{@comment_reply.id}", partial: "form", locals: { comment: @comment, comment_reply: @comment_reply, parent: @parent_nil }),
            turbo_stream.update("flash_message", partial: "shared/flash_message")
          ]
        end
        format.html {  }
      end
    end
  end

  def destroy
    @comment_reply.destroy!
    @comment_reply.broadcast_remove_to("comment_replies_list", target: "comment_reply_#{@comment_reply.id}")
    respond_to do |format|
      format.turbo_stream do
        flash.now[:success] = t("defaults.message.deleted", item: CommentReply.model_name.human)
        render turbo_stream: [
          turbo_stream.update("flash_message", partial: "shared/flash_message")
        ]
      end
      format.html {  }
    end
  end

  def search
    @q = @comment.comment_replies.ransack(params[:q])
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_reply_change_form", partial: "shared/comment_related_search", locals: { q: @q, url: comment_comment_replies_path(@comment), comment: @comment }) }
      format.html {  }
    end
  end

  def cancel_search
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_reply_change_form", partial: "comment_replies/comment_reply_button_part", locals: { comment: @comment }) }
      format.html {  }
    end
  end

  def unread
    @unread_objects = current_user.notified_reply_objects(@comment)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_reply_change_form", partial: "comment_replies/unread_comment_replies", locals: { unread_objects: @unread_objects, comment: @comment }) }
      format.html {  }
    end
  end

  def cancel_unread
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("comment_reply_change_form", partial: "comment_replies/comment_reply_button_part", locals: { comment: @comment }) }
      format.html {  }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:comment_id])
  end

  def set_comment_reply
    @comment_reply = current_user.comment_replies.find(params[:id])
  end

  def comment_reply_params
    params.require(:comment_reply).permit(:body, :comment_reply_image, :parent_id).merge(comment_id: params[:comment_id])
  end

  def comment_reply_update_params
    params.require(:comment_reply).permit(:body, :comment_reply_image, :parent_id)
  end
end
