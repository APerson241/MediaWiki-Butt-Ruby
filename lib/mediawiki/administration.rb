module MediaWiki
  module Administration
    # Blocks the user.
    # @param (see #unblock)
    # @param expiry [String] The expiry timestamp using a relative expiry time.
    # @param nocreate [Boolean] Whether to allow them to create an account.
    # @see https://www.mediawiki.org/wiki/API:Block MediaWiki Block API Docs
    # @since 0.5.0
    # @return (see #unblock)
    def block(user, expiry = '2 weeks', reason = nil, nocreate = true)
      params = {
        action: 'block',
        user: user,
        expiry: expiry
      }

      token = get_token('block')
      params[:reason] = reason unless reason.nil?
      params[:nocreate] = '1' if nocreate
      params[:token] = token

      response = post(params)

      response['error'].nil? ? response['id'].to_i : response['error']['code']
    end

    # Unblocks the user.
    # @param user [String] The user affected.
    # @param reason [String] The reason to show in the block log.
    # @see https://www.mediawiki.org/wiki/API:Block MediaWiki Block API Docs
    # @since 0.5.0
    # @return [String] The error code.
    # @return [Fixnum] The block ID.
    def unblock(user, reason = nil)
      params = {
        action: 'unblock',
        user: user
      }
      token = get_token('unblock')
      params[:reason] = reason unless reason.nil?
      params[:token] = token

      response = post(params)

      response['error'].nil? ? response['id'].to_i : response['error']['code']
    end
  end
end
