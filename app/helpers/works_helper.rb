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
  
end
