module WorksHelper
  
  # likely no longer required, RMW 2014-11-12
  def work_title( work )
    work.title
  end

  def sr_noun( vis )
    # correct noun on search report blurb
    if %w[objectmap thumbnails].include? vis
      'thumbnails for'
    elsif vis == 'treemap'
      'blocks for'
    else
      'records of'
    end
  end
  
  def is_i?( str )
    # fast way to test if string is simple, positive, base 10 number
    self.to_i.to_s == self
  end
end
