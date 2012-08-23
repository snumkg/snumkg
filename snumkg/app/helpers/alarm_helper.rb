
module  AlarmHelper
   def save_alarm_helper(hash = {}) 
    if hash[:acceptor_id] != hash[:alarmer_id]
      alarm = Alarm.new
      alarm.acceptor_id = hash[:acceptor_id]
      alarm.article_id = hash[:article_id]
      alarm.comment_id = hash[:comment_id]
      alarm.alarmer_id = hash[:alarmer_id]
      alarm.alarm_type = hash[:alarm_type]
      alarm.everyday_comment_id = hash[:everyday_comment_id]

      # 새로운 알람이 오면 카운트를 1 증가시킴
      if Alarm.where(:alarm_type => hash[:alarm_type], :article_id => hash[:article_id], :comment_id => hash[:comment_id], :acceptor_id => hash[:acceptor_id]).group_by(&:new)[true].nil?
        alarm.save
        alarm.acceptor.update_attribute(:alarm_counts, alarm.acceptor.alarm_counts + 1)
      else
        alarm.save
      end
    end
    
   end

   def destroy_alarm_helper(hash = {})
     if hash[:acceptor_id] != hash[:alarmer_id]
        alarms = Alarm.where(:acceptor_id => hash[:acceptor_id],
                    :alarmer_id => hash[:alarmer_id],
                    :article_id => hash[:article_id],
                    :comment_id => hash[:comment_id],
                    :alarm_type => hash[:alarm_type])

        for alarm in alarms
          alarm.destroy
        end
     end
   end
 
end
