require "proclaim/engine"

module Proclaim
	mattr_accessor :author_class
	@@author_class = "User"

	mattr_accessor :author_name_method
	@@author_name_method = :name

	mattr_accessor :current_author_method
	@@current_author_method = "current_#{@@author_class.underscore}".to_sym

	mattr_accessor :authentication_method
	@@authentication_method = "authenticate_#{@@author_class.underscore}!".to_sym

	mattr_accessor :excerpt_length
	@@excerpt_length = 500 # 500 characters (won't interrupt words)

	mattr_accessor :editor_toolbar_buttons
	@@editor_toolbar_buttons = ['bold', 'italic', 'underline', 'anchor',
	                            'header1', 'header2', 'quote']

	mattr_accessor :editor_whitelist_tags
	@@editor_whitelist_tags = %w(h1 h2 h3 h4 h5 h6
	                             div p blockquote
	                             ul ol li
	                             a b strong i u
	                             img figure
	                             pre sup sub br)

	mattr_accessor :editor_whitelist_attributes
	@@editor_whitelist_attributes = %w(class id style href title src alt align
	                                   draggable)

	mattr_accessor :mailer_sender
	@@mailer_sender = nil

	mattr_accessor :secret_key
	@@secret_key = nil

	# Callbacks (must be Procs)
	mattr_accessor :new_post_callbacks
	@@new_post_callbacks = Array.new
	private_class_method :new_post_callbacks, :new_post_callbacks=

	mattr_accessor :new_comment_callbacks
	@@new_comment_callbacks = Array.new
	private_class_method :new_comment_callbacks, :new_comment_callbacks=

	mattr_accessor :new_subscription_callbacks
	@@new_subscription_callbacks = Array.new
	private_class_method :new_subscription_callbacks,
	                     :new_subscription_callbacks=

	# Default way to setup Proclaim from initializer
	def self.setup
		yield self
	end

	def self.after_new_post(*callbacks, &block)
		callbacks.each do |callback|
			@@new_post_callbacks.unshift(callback)
		end

		if block_given?
			@@new_post_callbacks.unshift(block)
		end
	end

	def self.after_new_comment(*callbacks, &block)
		callbacks.each do |callback|
			@@new_comment_callbacks.unshift(callback)
		end

		if block_given?
			@@new_comment_callbacks.unshift(block)
		end
	end

	def self.after_new_subscription(*callbacks, &block)
		callbacks.each do |callback|
			@@new_subscription_callbacks.unshift(callback)
		end

		if block_given?
			@@new_subscription_callbacks.unshift(block)
		end
	end

	def self.notify_new_post(post)
		@@new_post_callbacks.each do |callback|
			callback.call(post)
		end
	end

	def self.notify_new_comment(comment)
		@@new_comment_callbacks.each do |callback|
			callback.call(comment)
		end
	end

	def self.notify_new_subscription(subscription)
		@@new_subscription_callbacks.each do |callback|
			callback.call(subscription)
		end
	end
end
