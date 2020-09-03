select
loginame,
 p.spid
, right(convert(varchar, 
 dateadd(ms, datediff(ms, P.last_batch, getdate()), '1900-01-01'), 
 121), 12) as 'batch_duration'
, P.program_name,p.*
from master.dbo.sysprocesses P
where P.spid > 50
and P.status not in ('background', 'sleeping')
and P.cmd not in ('AWAITING COMMAND'
 ,'MIRROR HANDLER'
 ,'LAZY WRITER'
 ,'CHECKPOINT SLEEP'
 ,'RA MANAGER')
order by batch_duration desc



SELECT conn.session_id, host_name, program_name,
    nt_domain, login_name, connect_time, last_request_end_time 
FROM sys.dm_exec_sessions AS sess
JOIN sys.dm_exec_connections AS conn
   ON sess.session_id = conn.session_id
   where sess.SESSION_id=109;



   WITH x AS 
(
 SELECT 
 session_id, 
 command,
 [status],
 s = DATEDIFF(SECOND, start_time, CURRENT_TIMESTAMP)
 FROM sys.dm_exec_requests AS r
 WHERE EXISTS 
 (
 SELECT 1 FROM sys.dm_exec_sessions 
 WHERE session_id = r.session_id
 AND is_user_process = 1
 )
 AND start_time < DATEADD(HOUR, -1, CURRENT_TIMESTAMP)
)
SELECT session_id, command, [status], s,
 CONVERT(VARCHAR(12), s / 86400) + ' days '
 + CONVERT(VARCHAR(2), (s % 86400) / 3600) + ' hours '
 + CONVERT(VARCHAR(2), (s % 86400) % 3600 / 60) + ' minutes.'
FROM x
ORDER BY s DESC;




SELECT sess.*
FROM sys.dm_exec_sessions AS sess
JOIN sys.dm_exec_connections AS conn
   ON sess.session_id = conn.session_id
   where sess.SESSION_id=109;

 

 SELECT   
    c.session_id, c.net_transport, c.encrypt_option,   
    c.auth_scheme, s.host_name, s.program_name,   
    s.client_interface_name, s.login_name, s.nt_domain,   
    s.nt_user_name, s.original_login_name, c.connect_time,   
    s.login_time   
FROM sys.dm_exec_connections AS c  
JOIN sys.dm_exec_sessions AS s  
    ON c.session_id = s.session_id  
WHERE c.session_id = 109;  