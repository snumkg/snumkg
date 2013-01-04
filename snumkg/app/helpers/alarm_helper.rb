
module  AlarmHelper
   def save_alarm_helper(hash = {})
    if hash[:acceptor_id] != hash[:alarmer_id]
      alarm_group = AlarmGroup.find_or_create_by_accepter_id_and_article_id_and_comment_id_and_alarm_type(
        hash[:accepter_id],
        hash[:article_id],
        hash[:comment_id],
        hash[:alarm_type]
      )

      alarm = Alarm.create(
        alarm_group_id: alarm_group.id,
        alarmer_id: hash[:alarmer_id]
      )

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
