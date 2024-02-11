# Changelog

All notable changes to this project will be documented in this file.

### [1.1.1](https://github.com/TheSudoYT/terraform-aws-palworld/compare/v1.1.0...v1.1.1) (2024-02-11)


### Bug Fixes

* **s3-regions:** Fix to support AWS regions that do not support legacy global endpoint ([97a5045](https://github.com/TheSudoYT/terraform-aws-palworld/commit/97a504554a7b4fe8865c96d26c4668beac718f21))

## [1.1.0](https://github.com/TheSudoYT/terraform-aws-palworld/compare/v1.0.3...v1.1.0) (2024-02-05)


### Features

* **ssm:** Inputs added to allow AWS SSM Session Manager for connecting and optional disabling of SSH ([45e790d](https://github.com/TheSudoYT/terraform-aws-palworld/commit/45e790d5848c8c1f04af5d4d52cc11012a33fe99))


### Bug Fixes

* **ports:** Fixed a bug in which a terraform apply with no changes would result in the ssh port being removed from state ([442a1cf](https://github.com/TheSudoYT/terraform-aws-palworld/commit/442a1cf9fb42632d66670c9acef0cd223670416d))

### [1.0.3](https://github.com/TheSudoYT/terraform-aws-palworld/compare/v1.0.2...v1.0.3) (2024-01-30)


### Bug Fixes

* **DeathPenalty:** Fixed DeathPenalty. Now takes 0,1,2 or 3 instead of string values ([cfa50b6](https://github.com/TheSudoYT/terraform-aws-palworld/commit/cfa50b60aae6317991ef92f47eb31f1096d7ee45))

### [1.0.2](https://github.com/TheSudoYT/terraform-aws-palworld/compare/v1.0.1...v1.0.2) (2024-01-30)


### Bug Fixes

* **game settings:** Fixed an issue preventing PalWorldSettings.ini values from reflecting in game ([4be07ed](https://github.com/TheSudoYT/terraform-aws-palworld/commit/4be07ed261d48eab547adeca9945ed2ffbafaa49))

### [1.0.1](https://github.com/TheSudoYT/terraform-aws-palworld/compare/v1.0.0...v1.0.1) (2024-01-27)


### Bug Fixes

* **restore from backup:** start_from_backup now enforces that a dedicated_server_name_hash be provided when true ([287cbf9](https://github.com/TheSudoYT/terraform-aws-palworld/commit/287cbf9928ae1dfbdfd0910653e8755f4e9e6f6a))

## 1.0.0 (2024-01-25)


### Features

* **release:** Initial Release ([29761f3](https://github.com/TheSudoYT/terraform-aws-palworld/commit/29761f31c2de91a9334bada57743f5cb718bbb0f))
