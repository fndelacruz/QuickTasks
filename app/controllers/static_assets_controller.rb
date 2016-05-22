class StaticAssetsController < ApplicationController
  CONTENT_TYPES = {
    'txt' => 'text/text',
    'js' => 'text/javascript',
    'css' => 'text/css',
    'jpg' => 'image/jpeg',
    'png' => 'image/png'
  }

  def show
    file = File.read("./public/#{params[:filepath]}")
    file_extension = params[:filepath].match(/.(\w+)$/)[1]
    content_type = CONTENT_TYPES[file_extension]
    render_content(file, content_type)
  rescue Errno::ENOENT => e
    if e.message.match /^No such file or directory @ rb_sysopen/
      throw_404
    end
  end

  private

  def throw_404
    res.status = 404
    res.write "404 asset not found"
  end
end
