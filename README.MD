<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSWordpress"><img src="https://img.shields.io/powershellgallery/v/PSWordpress.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSWordpress"><img src="https://img.shields.io/powershellgallery/vpre/PSWordpress.svg?label=powershell%20gallery%20preview&colorB=yellow"></a>
  <a href="https://github.com/EvotecIT/PSWordpress"><img src="https://img.shields.io/github/license/EvotecIT/PSWordpress.svg"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSWordpress"><img src="https://img.shields.io/powershellgallery/p/PSWordpress.svg"></a>
  <a href="https://github.com/EvotecIT/PSWordpress"><img src="https://img.shields.io/github/languages/top/evotecit/PSWordpress.svg"></a>
  <a href="https://github.com/EvotecIT/PSWordpress"><img src="https://img.shields.io/github/languages/code-size/evotecit/PSWordpress.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSWordpress"><img src="https://img.shields.io/powershellgallery/dt/PSWordpress.svg"></a>
</p>

<p align="center">
  <a href="https://twitter.com/PrzemyslawKlys"><img src="https://img.shields.io/twitter/follow/PrzemyslawKlys.svg?label=Twitter%20%40PrzemyslawKlys&style=social"></a>
  <a href="https://evotec.xyz/hub"><img src="https://img.shields.io/badge/Blog-evotec.xyz-2A6496.svg"></a>
  <a href="https://www.linkedin.com/in/pklys"><img src="https://img.shields.io/badge/LinkedIn-pklys-0077B5.svg?logo=LinkedIn"></a>
</p>

# PSWordpress - PowerShell Module

## Documentation - Development

PSWordpress uses Wordpress API. I've added minimal amount of cmdlets that I need for myself. Feel free to create issues or PRs when needing something more.

- [x] [Wordpress Rest API](https://developer.wordpress.org/rest-api/)
- [X] [Wordpress API](https://developer.wordpress.com/docs/api/)

## Installation

This **PowerShell** module requires installation of WordPress Plugin before it can be used. It can be used using one of 2 plugins.

1. Install [WP API SwaggerUI Wordpress Plugin](https://wordpress.org/plugins/wp-api-swaggerui/) to allow WordPress API via Basic Authentication

- Your login and password are the same as any user you create in WordPress
- Feel free to create new user with proper role rights that works with RestAPI

2. Install this PowerShell module

```powershell
Install-Module PSWordPress -Force
```

Alternatively (preffered method), you can use application passwords - that password to login to WordPress and password for REST API will be different.

1. Install [Application Passwords Wordpress Plugin](https://wordpress.org/plugins/application-passwords/)

- Go the **User Profil**e page of the user that you want to **generate a new application password** for.
- To do so, **click Users** on the left side of the **WordPress admin**, then click on the user that you want to manage.
- Scroll down until you see the **Application Passwords** section. This is typically at the bottom of the page.
- Within the input field, type in a name for your **new application password**, then click Add New.
- Note: The application password name is only used to describe your password for easy management later. It will not affect your password in any way. Be descriptive, as it will lead to easier management if you ever need to change it later.
- Once the Add New button is clicked, your **new application password** will appear. Be sure to keep this somewhere safe, as it will not be displayed to you again. If you lose this password, it cannot be obtained again.

2. Install this PowerShell module

```powershell
Install-Module PSWordPress -Force
```

## Usage
