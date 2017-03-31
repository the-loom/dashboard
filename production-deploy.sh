#!/bin/bash

echo "Se está por desplegar the-loom (master) en PRODUCCION."
read -p "Está seguro? " -n 1 -r
echo

echo ">>>>> Desplegando en producción"
echo ">>>>> Deteniendo servicios"
heroku maintenance:on --app the-loom
heroku pg:backups capture --app the-loom
curl -o the-loom-`date +"%Y%m%d"`.dump `heroku pg:backups public-url --app the-loom`
heroku ps:scale web=0 --app the-loom
echo ">>>>> Actualizando código fuente"
git push production master
echo ">>>>> Ejecutando migraciones"
heroku pg:killall --app the-loom
heroku run rake db:migrate --app the-loom
echo ">>>>> Restaurando servicios"
heroku ps:scale web=1 --app the-loom
heroku restart --app the-loom
heroku maintenance:off --app the-loom
echo ">>>>> Generando marcas de despliegue"
git tag prod`date +"%Y%m%d"`
git push origin --tags
echo ">>>>> Despliegue terminado"
