select c.name as Curso, u.id as uid, u.last_name as Apellido, u.first_name as Nombre, u.email as correo,
       case m.enabled when true then 'SI' when false then 'NO' end as Activo,
       sum(a.multiplier) as Asistencias,
       coalesce(q1.multiplier / 2.0, 0) as Cuestionario_1,
       coalesce(t1.multiplier / 2.0, 0) as TP_1,
       coalesce(q2.multiplier / 2.0, 0) as Cuestionario_2,
       coalesce(t2.multiplier / 2.0, 0) as TP_2,
       coalesce(q3.multiplier / 2.0, 0) as Cuestionario_3,
       coalesce(t3.multiplier / 2.0, 0) as TP_3
from memberships m
         left join occurrences a on m.user_id = a.user_id and a.event_id = 344
         left join occurrences q1 on m.user_id = q1.user_id and q1.event_id = 483
         left join occurrences t1 on m.user_id = t1.user_id and t1.event_id = 484
         left join occurrences q2 on m.user_id = q2.user_id and q2.event_id = 487
         left join occurrences t2 on m.user_id = t2.user_id and t2.event_id = 488
         left join occurrences q3 on m.user_id = q3.user_id and q3.event_id = 491
         left join occurrences t3 on m.user_id = t3.user_id and t3.event_id = 492
         join users u on m.user_id = u.id
         join courses c on c.id = m.course_id
where m.course_id between 35 and 46
  and m.role = 1
  -- la siguiente fila es para el informe de Concordia
  and m.user_id in (1004, 1009, 1048, 1063, 1501, 1501, 1512, 1513, 1515, 1516, 1529, 1533, 1536, 1537, 1539, 1541, 1543, 1546, 1547, 1549, 1552, 1574, 1577, 1581, 1583, 1585, 1586, 1589, 1591, 1593, 1596, 1608, 1609, 1611, 1649, 1650, 1659, 1661, 1668, 1670, 1673, 1674, 1678, 1679, 1680, 1683, 1685, 1690, 1697, 1699, 1700, 1703, 1704, 1706, 1708, 1710, 1711, 1717, 1718, 1720, 1728, 1731, 1826, 1830, 1833, 1835, 1835, 1837, 1839, 1841, 1843, 1844, 1845, 1846, 1847, 1850, 1852, 1856, 1857, 1860, 1862, 1862, 1866, 1871, 1889, 1897, 1901, 1998, 2007, 2012, 2015, 2017, 2023, 2024, 2025, 2027, 2028, 2029, 2030, 2032, 2033, 2034, 2035, 2036, 2038, 2042, 2043, 2047, 2049, 2052, 2053, 2054, 2056, 2059, 2071, 2073, 2073, 2096, 2097, 2098, 2100, 2103, 2107, 2108, 2110, 2116, 2117, 2124, 2125, 2130, 2131, 2132, 2135, 2136, 2141, 2142, 2143, 2144, 2145, 2153, 2154, 2157, 2159)
group by curso, uid, apellido, nombre, correo, activo, cuestionario_1, tp_1, Cuestionario_2, TP_2, Cuestionario_3, TP_3
order by 5 desc, 1 asc, 2 asc, 3 asc;