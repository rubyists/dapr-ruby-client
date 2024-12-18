## [Unreleased]

## [0.4.3](https://github.com/rubyists/dapr-ruby-client/compare/v0.4.2...v0.4.3) (2024-12-16)


### Features

* **notrly:** Force a release by updating the readme with current dapr version ([#81](https://github.com/rubyists/dapr-ruby-client/issues/81)) ([e249b46](https://github.com/rubyists/dapr-ruby-client/commit/e249b4698d34eef1178bae8a7447293563494990))

## [0.4.2](https://github.com/rubyists/dapr-ruby-client/compare/v0.4.1...v0.4.2) (2024-12-16)


### Bug Fixes

* **build:** Vendor gems for quicker image builds ([#78](https://github.com/rubyists/dapr-ruby-client/issues/78)) ([57fbe12](https://github.com/rubyists/dapr-ruby-client/commit/57fbe126390aa9f5aebcf06d4f42bd5e1ff3ee63))

## [0.4.1](https://github.com/rubyists/dapr-ruby-client/compare/v0.4.0...v0.4.1) (2024-10-24)


### Bug Fixes

* **state:** Updates State#get to return a Hash instead of an Array ([#76](https://github.com/rubyists/dapr-ruby-client/issues/76)) ([052fcfa](https://github.com/rubyists/dapr-ruby-client/commit/052fcfa6ca6077e13343738d38b5768e693b4c9b))

## [0.4.0](https://github.com/rubyists/dapr-ruby-client/compare/v0.3.3...v0.4.0) (2024-10-23)


### ⚠ BREAKING CHANGES

* **state:** Adds state management component ([#74](https://github.com/rubyists/dapr-ruby-client/issues/74))

### Features

* **state:** Adds state management component ([#74](https://github.com/rubyists/dapr-ruby-client/issues/74)) ([2fc596d](https://github.com/rubyists/dapr-ruby-client/commit/2fc596dad1439c5d52a03bdf763d8b0d38aa9bab))

## [0.3.3](https://github.com/rubyists/dapr-ruby-client/compare/v0.3.2...v0.3.3) (2024-10-08)


### Features

* **grpc:** Update grpc to 1.66 in container ([#71](https://github.com/rubyists/dapr-ruby-client/issues/71)) ([da78331](https://github.com/rubyists/dapr-ruby-client/commit/da783315276b27c4a1b37996198021f415adf4cf))


### Bug Fixes

* **lock:** Updates lock/unlock to append _alpha1 ([#72](https://github.com/rubyists/dapr-ruby-client/issues/72)) ([847d091](https://github.com/rubyists/dapr-ruby-client/commit/847d0910265df8c37edf5d2af4eed0c0f6d4feb0))

## [0.3.2](https://github.com/rubyists/dapr-ruby-client/compare/v0.3.1...v0.3.2) (2024-07-19)


### Features

* **grpc:** Update grpc to 1.65.1 ([#69](https://github.com/rubyists/dapr-ruby-client/issues/69)) ([536dec9](https://github.com/rubyists/dapr-ruby-client/commit/536dec92730f3578de368d19c8150d701a6aac1b))

## [0.3.1](https://github.com/rubyists/dapr-ruby-client/compare/v0.3.0...v0.3.1) (2024-06-03)


### Bug Fixes

* Remove owner/ from the published ghcr.io image ([#67](https://github.com/rubyists/dapr-ruby-client/issues/67)) ([47100ba](https://github.com/rubyists/dapr-ruby-client/commit/47100ba1b4621ad351e8349a2b185ac4bd424c21))

## [0.3.0](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.11...v0.3.0) (2024-06-03)


### ⚠ BREAKING CHANGES

* Forcing release with a brilliant feature ([#64](https://github.com/rubyists/dapr-ruby-client/issues/64))

### Features

* Forcing release with a brilliant feature ([#64](https://github.com/rubyists/dapr-ruby-client/issues/64)) ([05dcacd](https://github.com/rubyists/dapr-ruby-client/commit/05dcacd5278a622fed94acdbc025d98b621b948a))

## [0.2.11](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.10...v0.2.11) (2024-06-03)


### Bug Fixes

* **build:** Lowers concurrency for container jobs to 1 ([#59](https://github.com/rubyists/dapr-ruby-client/issues/59)) ([70c1c56](https://github.com/rubyists/dapr-ruby-client/commit/70c1c56990dbf4a87f8088b40483a213a674f793))
* Use secret references in matrix values ([#61](https://github.com/rubyists/dapr-ruby-client/issues/61)) ([9f45785](https://github.com/rubyists/dapr-ruby-client/commit/9f4578546cc77da79c5548347bee1b2ed6e790ec))
* Uses correct rubygems secret ([#60](https://github.com/rubyists/dapr-ruby-client/issues/60)) ([5de5ff4](https://github.com/rubyists/dapr-ruby-client/commit/5de5ff44bf0b06ee1652616f58c29a411ecb4e18))

## [0.2.10](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.9...v0.2.10) (2024-06-03)


### Bug Fixes

* Release testing PR ([#57](https://github.com/rubyists/dapr-ruby-client/issues/57)) ([1f56abf](https://github.com/rubyists/dapr-ruby-client/commit/1f56abfb350c8d4886fcc2a2fd7183b2f6456d35))
* **workflow:** Corrects workflow syntax ([#55](https://github.com/rubyists/dapr-ruby-client/issues/55)) ([dee10a4](https://github.com/rubyists/dapr-ruby-client/commit/dee10a4a9475f73b1b52bbc0408564c05bc83ab8))

## [0.2.9](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.8...v0.2.9) (2024-06-03)


### Features

* **builds:** Use matrix to build containers ([#52](https://github.com/rubyists/dapr-ruby-client/issues/52)) ([0f1ed51](https://github.com/rubyists/dapr-ruby-client/commit/0f1ed510984806b08a6c267ad36c4f8fca6478f8))

## [0.2.8](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.7...v0.2.8) (2024-06-03)


### Bug Fixes

* Adds type declaration to workflow inputs ([#50](https://github.com/rubyists/dapr-ruby-client/issues/50)) ([3203b1c](https://github.com/rubyists/dapr-ruby-client/commit/3203b1cfa383f58b61a7fc00f57bbd007c1ff494))
* **build:** Corrects name of image build script ([#49](https://github.com/rubyists/dapr-ruby-client/issues/49)) ([04ff29e](https://github.com/rubyists/dapr-ruby-client/commit/04ff29e5812ac5986f3ec01b10300c566d12979c))

## [0.2.7](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.6...v0.2.7) (2024-06-03)


### Features

* **lock:** Release distributed lock component ([#47](https://github.com/rubyists/dapr-ruby-client/issues/47)) ([706d6d5](https://github.com/rubyists/dapr-ruby-client/commit/706d6d58e93c70a25db56ae8bf94975e36963509))

## [0.2.6](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.5...v0.2.6) (2024-06-03)


### Features

* Document Configuration for consumption ([#43](https://github.com/rubyists/dapr-ruby-client/issues/43)) ([5142d5b](https://github.com/rubyists/dapr-ruby-client/commit/5142d5bc85a2c4aa5da18aa91897569118d645df))

## [0.2.5](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.4...v0.2.5) (2024-06-03)


### Bug Fixes

* **ci:** Move conditional to the run script ([#40](https://github.com/rubyists/dapr-ruby-client/issues/40)) ([cb8a15f](https://github.com/rubyists/dapr-ruby-client/commit/cb8a15f60d55928258c832005607a0368ba84b40))
* **ci:** Only publish gem when release is created ([#38](https://github.com/rubyists/dapr-ruby-client/issues/38)) ([086382f](https://github.com/rubyists/dapr-ruby-client/commit/086382fbd368088ca6d3e590dc9daaeb2684bf42))

## [0.2.4](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.3...v0.2.4) (2024-06-03)


### Bug Fixes

* Adds codeql scanning back to the release pipeline ([#29](https://github.com/rubyists/dapr-ruby-client/issues/29)) ([0b0d602](https://github.com/rubyists/dapr-ruby-client/commit/0b0d602db68dd8bf6583552a2e7d92276135be8f))
* Uses .yaml suffix for all yaml files ([8c7aaf9](https://github.com/rubyists/dapr-ruby-client/commit/8c7aaf98eeb5d9eb6d7a74bf0fb574654e150a83))

## [0.2.3](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.2...v0.2.3) (2024-06-03)


### Bug Fixes

* Hack it up to allow publishing to multiple gem package repos ([#26](https://github.com/rubyists/dapr-ruby-client/issues/26)) ([e59ca38](https://github.com/rubyists/dapr-ruby-client/commit/e59ca38bf2aee9950ef84bd57548f0f3d81c402d))

## [0.2.2](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.1...v0.2.2) (2024-06-02)


### Bug Fixes

* It helps to check out the code before building a gem ([#24](https://github.com/rubyists/dapr-ruby-client/issues/24)) ([8bfd14e](https://github.com/rubyists/dapr-ruby-client/commit/8bfd14eee9b548916afe028fc19a4c1a6088ec78))

## [0.2.1](https://github.com/rubyists/dapr-ruby-client/compare/v0.2.0...v0.2.1) (2024-06-02)


### Features

* Adds separate callable gem publish workflow ([#21](https://github.com/rubyists/dapr-ruby-client/issues/21)) ([96dbb03](https://github.com/rubyists/dapr-ruby-client/commit/96dbb034fcc2fdc8e6a51bba92250eeffe5e7630))


### Bug Fixes

* Corrects release flow so gem does not require release ([#22](https://github.com/rubyists/dapr-ruby-client/issues/22)) ([5ea0bca](https://github.com/rubyists/dapr-ruby-client/commit/5ea0bca485f94204e468ac425d3dd0619088dacb))

## [0.2.0](https://github.com/rubyists/dapr-ruby-client/compare/v0.1.27...v0.2.0) (2024-06-02)


### ⚠ BREAKING CHANGES

* **dep:** Adds overcommit development dependency ([#19](https://github.com/rubyists/dapr-ruby-client/issues/19))

### Features

* **dep:** Adds overcommit development dependency ([#19](https://github.com/rubyists/dapr-ruby-client/issues/19)) ([37687b1](https://github.com/rubyists/dapr-ruby-client/commit/37687b197c61374613b8a88f7996a1adb1980bd1))

## [0.1.0] - 2024-04-15

- Initial release
