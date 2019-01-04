url = 'https://hanzo.ai'

name = """
  Hanzo Platform
  """

description = """
  Hanzo Platform
  """

twitter =
  username: ''
  hashtags: 'hanzo'
  text:     ''

facebook =
  username: ''

module.exports =
  site:
    title:     name
    name:      name
    url:       url
    copyright: '© ' + name + ' ' + (new Date()).getFullYear()

  meta:
    description: description

    facebook:
      # appid:       '1648878842071733'
      title:       name
      description: description
      # image:       'https://getshopjs.com/img/logo.png'

    twitter:
      title:       name
      description: description
      # image:       'https://getshopjs.com/img/logo.png'

  social:
    twitter:
      username:  "@#{twitter.username}"
      shareLink: "https://twitter.com/intent/tweet?url=#{encodeURIComponent url}&text=#{encodeURIComponent twitter.text}&hashtags=#{twitter.hashtags}&via=#{twitter.username}&original_referer=#{encodeURIComponent url}"
    facebook:
      username:  facebook.username
      shareLink: 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent url
    googlePlus:
      shareLink: 'https://plus.google.com/share?url=' + encodeURIComponent url

  id: 'yoursite'
  version: (new Date()).getTime()

