CREATE TABLE if not exists CachedImagesTable (id integer primary key autoincrement, imgKey text, imgSize text, imgData blob, cacheTime bigint);

CREATE TABLE if not exists CachedResizedImagesTable (id integer primary key autoincrement, imgKey text, imgSize text, imgData blob, cacheTime bigint);