select c.name as Curso, u.id as uid, u.last_name as Apellido, u.first_name as Nombre, u.email,
       case m.enabled when true then 'SI' when false then 'NO' end as Activo,
       sum(a.multiplier) as Asistencias,
       coalesce(q1.multiplier / 2.0, 0) as Cuestionario_1,
       coalesce(t1.multiplier / 2.0, 0) as TP_1,
       coalesce(q2.multiplier / 1.4, 0) as Cuestionario_2,
       coalesce(t2.multiplier / 2.0, 0) as TP_2,
        coalesce(q3.multiplier / 2.0, 0) as Cuestionario_3,
        coalesce(t3.multiplier / 2.0, 0) as TP_3
from memberships m
         left join occurrences a on m.user_id = a.user_id and a.event_id = 478
         left join occurrences q1 on m.user_id = q1.user_id and q1.event_id = 485
         left join occurrences t1 on m.user_id = t1.user_id and t1.event_id = 486
         left join occurrences q2 on m.user_id = q2.user_id and q2.event_id = 489
         left join occurrences t2 on m.user_id = t2.user_id and t2.event_id = 490
         left join occurrences q3 on m.user_id = q3.user_id and q3.event_id = 494
         left join occurrences t3 on m.user_id = t3.user_id and t3.event_id = 493
         join users u on m.user_id = u.id
         join courses c on c.id = m.course_id
where m.course_id between 54 and 55
  and m.role = 1
group by curso, uid, apellido, nombre, activo, cuestionario_1, tp_1, cuestionario_2, tp_2, cuestionario_3, tp_3
order by 4 desc, 1 asc, 2 asc, 3 asc;