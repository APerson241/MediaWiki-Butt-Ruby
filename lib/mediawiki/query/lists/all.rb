module MediaWiki
  module Query
    module Lists
      module All
        # Gets all categories on the entire wiki.
        # @param limit [Fixnum] The maximum number of categories to get. Cannot be greater than 500 for users or 5000
        #   for bots.
        # @see https://www.mediawiki.org/wiki/API:Allcategories MediaWiki Allcategories API Docs
        # @since 0.7.0
        # @return [Array<String>] An array of all categories.
        def get_all_categories(limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'allcategories',
            aclimit: get_limited(limit)
          }

          response = post(params)

          ret = []
          response['query']['allcategories'].each { |c| ret << c['*'] }

          ret
        end

        # Gets all the images on the wiki.
        # @param (see #get_all_categories)
        # @see https://www.mediawiki.org/wiki/API:Allimages MediaWiki Allimages API Docs
        # @since 0.7.0
        # @return [Array<String>] An array of all images.
        def get_all_images(limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'allimages',
            ailimit: get_limited(limit)
          }

          response = post(params)

          ret = []
          response['query']['allimages'].each { |i| ret << i['name'] }

          ret
        end

        # Gets all pages within a namespace integer.
        # @param namespace [Fixnum] The namespace ID.
        # @param (see #get_all_categories)
        # @see https://www.mediawiki.org/wiki/API:Allpages MediaWiki Allpages API Docs
        # @since 0.8.0
        # @return [Array<String>] An array of all page titles.
        def get_all_pages_in_namespace(namespace, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'allpages',
            apnamespace: namespace,
            aplimit: get_limited(limit)
          }

          response = post(params)

          ret = []
          response['query']['allpages'].each { |p| ret << p['title'] }

          ret
        end

        # Gets all users, or all users in a group.
        # @param group [String] The group to limit this query to.
        # @param (see #get_all_categories)
        # @see https://www.mediawiki.org/wiki/API:Allusers MediaWiki Allusers API Docs
        # @since 0.8.0
        # @return [Hash<String, Fixnum>] A hash of all users, names are keys, IDs are values.
        def get_all_users(group = nil, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'allusers',
            aulimit: get_limited(limit)
          }
          params[:augroup] = group unless group.nil?

          response = post(params)

          ret = {}
          response['query']['allusers'].each { |u| ret[u['name']] = u['userid'] }

          ret
        end

        # Gets all block IDs on the wiki. It seems like this only gets non-IP blocks, but the MediaWiki docs are a
        # bit unclear.
        # @param (see #get_all_categories)
        # @see https://www.mediawiki.org/wiki/API:Blocks MediaWiki Blocks API Docs
        # @since 0.8.0
        # @return [Array<Fixnum>] All block IDs as strings.
        def get_all_blocks(limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'blocks',
            bklimit: get_limited(limit),
            bkprop: 'id'
          }

          response = post(params)

          ret = []
          response['query']['blocks'].each { |b| ret.push(b['id']) }

          ret
        end

        # Gets all page titles that transclude a given page.
        # @param page [String] The page name.
        # @param (see #get_all_categories)
        # @see https://www.mediawiki.org/wiki/API:Embeddedin MediaWiki Embeddedin API Docs
        # @since 0.8.0
        # @return [Array<String>] All transcluder page titles.
        def get_all_transcluders(page, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'embeddedin',
            eititle: page,
            eilimit: get_limited(limit)
          }

          response = post(params)

          ret = []
          response['query']['embeddedin'].each { |e| ret << e['title'] }

          ret
        end

        # Gets an array of all deleted or archived files on the wiki.
        # @param (see #get_all_categories)
        # @see https://www.mediawiki.org/wiki/API:Filearchive MediaWiki Filearchive API Docs
        # @since 0.8.0
        # @return [Array<String>] All deleted file names. These are not titles, so they do not include "File:".
        def get_all_deleted_files(limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'filearchive',
            falimit: get_limited(limit)
          }

          response = post(params)

          ret = []
          response['query']['filearchive'].each { |f| ret.push(f['name']) }

          ret
        end

        # Gets a list of all protected pages, by protection level if provided.
        # @param protection_level [String] The protection level, e.g., sysop
        # @param (see #get_all_categories)
        # @see https://www.mediawiki.org/wiki/API:Protectedtitles MediaWiki Protectedtitles API Docs
        # @since 0.8.0
        # @return [Array<String>] All protected page titles.
        def get_all_protected_titles(protection_level = nil, limit = @query_limit_default)
          params = {
            action: 'query',
            list: 'protectedtitles',
            ptlimit: get_limited(limit)
          }
          params[:ptlevel] = protection_level unless protection_level.nil?

          response = post(params)

          ret = []
          response['query']['protectedtitles'].each { |t| ret << t['title'] }

          ret
        end
      end
    end
  end
end
