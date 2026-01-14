# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Nothing yet...


## [3.0.0] - 2024-03-17

### Added
 - Tests inside of `Rule` elements are now taken into account when slicing.

### Removed
  - Removed support for some older versions of the gem's dependencies:
    - CukeModeler `0.x`, CukeModeler `1.x`, and CukeModeler `2.x`. Slicing features with `Rule` elements requires at
      least CukeModeler `3.x`, because that is the major version that first modeled rules.
    - Ruby `1.x`. Testing against older Rubies in the current CI ecosystem has become too burdensome and Ruby `1.x` is 
      long past end-of-life. Additionally, CukeModeler `3.x` requires at least Ruby `2.3`.
    
### Changed
  - No longer including every file in the Git repository as part of the gem. Only the files needed for using the 
    gem (and the informative ones like the README) will be packaged into the released gem.

## [2.2.0] - 2021-01-07

### Added
 - Ruby 3.x is now supported

## [2.1.0] - 2020-06-22

### Added
 - Added support for `cuke_modeler` 2.x and 3.x

## [2.0.3] - 2019-05-01

### Added

 - Add dependency version limits to Ruby, which was previously unbound. Previously unofficially supported Ruby versions (1.9.3 - 2.x) are now officially supported.


## [2.0.2] - 2016-11-19

### Added

 -  The gem now declares version limits for all of its dependencies.


## [2.0.1] - 2016-11-08 (yanked)

### Added

 - Works with both 0.x and 1.x versions of the 'cuke_modeler' gem.


## [2.0.0] - 2015-07-08

### Added

 - When slicing a directory, the test cases returned can now be provided as model objects in addition to the
   previous 'file_path:line_number' format.

### Changed

 -  Major performance increase


## [1.0.0] - 2015-04-01

### Added

 - Initial release

[Unreleased]: https://github.com/enkessler/cuke_slicer/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/enkessler/cuke_slicer/compare/v2.2.0...v3.0.0
[2.2.0]: https://github.com/enkessler/cuke_slicer/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/enkessler/cuke_slicer/compare/v2.0.3...v2.1.0
[2.0.3]: https://github.com/enkessler/cuke_slicer/compare/v2.0.2...v2.0.3
[2.0.2]: https://github.com/enkessler/cuke_slicer/compare/v2.0.1...v2.0.2
[2.0.1]: https://github.com/enkessler/cuke_slicer/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/enkessler/cuke_slicer/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/enkessler/cuke_slicer/compare/1c6e64b963d97f9037f1dc1ebcb6f8f9966f3b71...v1.0.0
