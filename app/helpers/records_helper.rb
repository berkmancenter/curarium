module RecordsHelper
  
  def record_title( record )
    title = JSON.parse record.parsed[ 'title' ]
    if title.any?
      title[ 0 ]
    else
      ''
    end
  end
  
end
