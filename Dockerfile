FROM node:14.4.0-alpine3.10

WORKDIR /app

ADD package.json package-lock.json /app/
RUN npm install
ADD app.js geocoder.js /app/

RUN apk add --no-cache curl && \
    mkdir -p \
        /app/geonames_dump/admin1_codes \
        /app/geonames_dump/admin2_codes \
        /app/geonames_dump/all_countries \
        /app/geonames_dump/alternate_names \
        /app/geonames_dump/cities && \
    cd /app/geonames_dump && \

    curl -L -o all_countries/allCountries.zip http://download.geonames.org/export/dump/allCountries.zip && \
    curl -L -o alternate_names/alternateNames.zip http://download.geonames.org/export/dump/alternateNames.zip && \
    curl -L -o cities/cities1000.zip http://download.geonames.org/export/dump/cities1000.zip && \
    cd all_countries && unzip allCountries.zip && rm allCountries.zip && cd .. && \
    cd cities && unzip cities1000.zip && rm cities1000.zip && cd .. && \
    cd alternate_names && unzip alternateNames.zip && rm alternateNames.zip

ENTRYPOINT ["npm"]
CMD ["start"]

