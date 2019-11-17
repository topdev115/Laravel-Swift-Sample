# Laravel-Swift-Sample

![](https://img.shields.io/badge/sample%20project-v1.0-blue)
The Swift App Sample with Laravel RESTful API.

![](https://res.cloudinary.com/ddyyw1ytz/image/upload/v1573950930/screenshot-1_jqizzo.png)![](https://res.cloudinary.com/ddyyw1ytz/image/upload/v1573950930/screenshot-2_kemr40.png)![](https://res.cloudinary.com/ddyyw1ytz/image/upload/v1573950931/screenshot-3_i2uc8x.png)![](https://res.cloudinary.com/ddyyw1ytz/image/upload/v1573950931/screenshot-4_dogysc.png)![](https://res.cloudinary.com/ddyyw1ytz/image/upload/v1573950931/screenshot-5_zf5v8m.png)![](https://res.cloudinary.com/ddyyw1ytz/image/upload/v1573950930/screenshot-6_r8v2u5.png)

## Contents
- [Laravel](https://laravel.com/) Project for RESTful API (6.5.1 released) - [ApiServer]
- The iOS Project using API ([Swift](https://developer.apple.com/swift/) 5.0) - [TestApi]

## Pre-Requisites
1. MacOS Mojave 10.14.3 or above
1. [Git](https://git-scm.com/)
1. [Apache2](https://httpd.apache.org/),  [PHP 7.2](https://www.php.net/) or above,  [MySQL](https://www.mysql.com/) or [MariaDB](https://mariadb.org)
1. [Composer](https://getcomposer.org/)
1. [Xcode 11.0](https://developer.apple.com/documentation/xcode_release_notes/xcode_11_release_notes) or above
   To test the app on physical device, You'll need an [Apple Developer Account](https://developer.apple.com/)
1. [CocoaPods](https://cocoapods.org)

## Installation
Clone the repository in your pc using git.
```sh
$ git clone https://github.com/superdev115/Laravel-Swift-Sample.git
$ cd Laravel-Swift-Sample
```
### Laravel Project
- Install the application's dependencies with Composer
    ```sh
    $ cd ApiServer
    $ composer install
    ```
- Create a new database for project. (MySQL).
    You can use Terminal like this
    ```sh
    mysql -u root -p
    mysql> CREATE DATABASE <your_database_name>;
    ```
    or you can use phpMyAdmin.
- Copy the sample configuration file and edit it to match your configuration.
    ```sh
    $ cp .env.example .env
    ```
    You'll need to set `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, and `DB_PASSWORD`.
- Run the application by using Artisan commands.
    Clear cache
    ```sh
    $ php artisan cache:clear
    ```
    Generate the `APP_KEY`
    ```sh
    $ php artisan key:generate
    ```
    Run the migrations
    ```sh
    $ php artisan migrate
    ```
    Seed fake data
    ```sh
    $ php php artisan db:seed
    ```
    Run the application using Artisan
    ```sh
    $ php artisan serve
    ```
### Swift Project
Install pods using cocoapods.
    
    $ cd TestApi
    $ pod install
    
Open TestApi.xcworkspace file.

## Pod Configuration for Swift Project 

The swift project has some pods.

| Pod name | Reference |
| ------ | ------ |
| Alamofire | https://github.com/Alamofire/Alamofire |
| SwiftyJSON | https://github.com/SwiftyJSON/SwiftyJSON |
| Kingfisher | https://github.com/onevcat/Kingfisher |
| SQLite.swift | https://github.com/stephencelis/SQLite.swift |
| SwiftEventBus | https://github.com/cesarferreira/SwiftEventBus |
| MaterialComponents/Snackbar | https://material.io/develop/ios/components/snackbars |

## License
MIT

----

**Free Source Code, Hell Yeah!**