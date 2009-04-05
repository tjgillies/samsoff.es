class PostsController < ApplicationController
	before_filter :authenticate, :except => [:index, :show]
	caches_page :index, :show, :new
	cache_sweeper :post_sweeper, :only => [:create, :update, :destroy]

	def index
    @posts = Post.search(nil, 1)
	  render :action => 'page'
	end
	
	def page
	  @posts = Post.search(nil, params[:page])
	end
	
	def show
	  if params[:slug]
	    @post = Post.find_by_slug(params[:slug])
	    raise ActiveRecord::RecordNotFound, 'Post not found' if @post.nil?
	  else
	    @post = Post.find(params[:id])
	  end
	end

	def new
		@post = Post.new
	end

	def edit
		@post = Post.find(params[:id])
	end

	def create
		@post = Post.new(params[:post])

		if @post.save
			flash[:notice] = 'Post was successfully created.'
			redirect_to(@post)
		else
			render :action => "new"
		end
	end

	def update
		@post = Post.find(params[:id])
		
		if @post.update_attributes(params[:post])
			flash[:notice] = 'Post was successfully updated.'
			redirect_to(@post)
		else
			render :action => "edit"
		end
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy

	  redirect_to(posts_url)
	end
	
	private
	
	def authenticate
		authenticate_or_request_with_http_basic do |name, password|
			name == "admin"  && password == "passw0rd"
		end
	end
end
