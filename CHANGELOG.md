# Change Log

## [v0.6.0](https://github.com/danielberkompas/ex_twilio/tree/v0.6.0) (2018-04-16)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.5.1...v0.6.0)

**Closed issues:**

- HTTPoison.Error :nxdomain in lib/ex\_twilio/api.ex:19 [\#88](https://github.com/danielberkompas/ex_twilio/issues/88)

**Merged pull requests:**

- Add JWT support [\#92](https://github.com/danielberkompas/ex_twilio/pull/92) ([danielberkompas](https://github.com/danielberkompas))
- fix next\_page\_url generation & run mix format [\#91](https://github.com/danielberkompas/ex_twilio/pull/91) ([techgaun](https://github.com/techgaun))
- feat\(RequestValidator\): Adds a module that handles validating request… [\#90](https://github.com/danielberkompas/ex_twilio/pull/90) ([tomciopp](https://github.com/tomciopp))
- chore\(docs\): Default to reading from system environment variables [\#89](https://github.com/danielberkompas/ex_twilio/pull/89) ([tomciopp](https://github.com/tomciopp))

## [v0.5.1](https://github.com/danielberkompas/ex_twilio/tree/v0.5.1) (2018-02-24)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.5.0...v0.5.1)

**Closed issues:**

- Retrieving A Programmable Chat User. [\#85](https://github.com/danielberkompas/ex_twilio/issues/85)

**Merged pull requests:**

- Refactor ExTwilio.ResultStream to simplify streaming code [\#87](https://github.com/danielberkompas/ex_twilio/pull/87) ([scarfacedeb](https://github.com/scarfacedeb))
- Remove puts that could not be muted [\#86](https://github.com/danielberkompas/ex_twilio/pull/86) ([john-griffin](https://github.com/john-griffin))
- Config does not need system [\#82](https://github.com/danielberkompas/ex_twilio/pull/82) ([mahcloud](https://github.com/mahcloud))

## [v0.5.0](https://github.com/danielberkompas/ex_twilio/tree/v0.5.0) (2017-09-21)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.4.0...v0.5.0)

**Closed issues:**

- Update to Poison \>= 3 [\#72](https://github.com/danielberkompas/ex_twilio/issues/72)

**Merged pull requests:**

- Add all endpoints for the programmable chat api. [\#81](https://github.com/danielberkompas/ex_twilio/pull/81) ([4141done](https://github.com/4141done))
- Remove someone's hardcoded workspace sid from the url\_builder [\#80](https://github.com/danielberkompas/ex_twilio/pull/80) ([4141done](https://github.com/4141done))
- Handle query string encoding of list values for the param map. [\#79](https://github.com/danielberkompas/ex_twilio/pull/79) ([m4ttsch](https://github.com/m4ttsch))

## [v0.4.0](https://github.com/danielberkompas/ex_twilio/tree/v0.4.0) (2017-07-10)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.3.0...v0.4.0)

**Closed issues:**

- Subaccounts support [\#76](https://github.com/danielberkompas/ex_twilio/issues/76)
- Add messaging\_service\_sid to the Message Resource [\#75](https://github.com/danielberkompas/ex_twilio/issues/75)
- Setting MaxPrice on message [\#70](https://github.com/danielberkompas/ex_twilio/issues/70)
- Error while creating sms [\#69](https://github.com/danielberkompas/ex_twilio/issues/69)

**Merged pull requests:**

- 76 - Subaccounts handling [\#78](https://github.com/danielberkompas/ex_twilio/pull/78) ([andrewshatnyy](https://github.com/andrewshatnyy))
- Upgrade Joken to 1.4.1 [\#74](https://github.com/danielberkompas/ex_twilio/pull/74) ([joshuafleck](https://github.com/joshuafleck))
- Replace 'accound' with 'account' in capability.ex [\#73](https://github.com/danielberkompas/ex_twilio/pull/73) ([SherSpock](https://github.com/SherSpock))
- Adds Update API action to Conference resource. [\#71](https://github.com/danielberkompas/ex_twilio/pull/71) ([m4ttsch](https://github.com/m4ttsch))

## [v0.3.0](https://github.com/danielberkompas/ex_twilio/tree/v0.3.0) (2017-01-20)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.2.1...v0.3.0)

**Closed issues:**

- Configure accound\_sid and auth\_token in run time [\#65](https://github.com/danielberkompas/ex_twilio/issues/65)
- protocol String.Chars not implemented for %{"mms" =\> false, "sms" =\> false, "voice" =\> true} [\#57](https://github.com/danielberkompas/ex_twilio/issues/57)
- problem with lib [\#52](https://github.com/danielberkompas/ex_twilio/issues/52)
- Notifications API url broken [\#46](https://github.com/danielberkompas/ex_twilio/issues/46)

**Merged pull requests:**

- \[\#65\] Allow runtime config with {:system} tuples [\#66](https://github.com/danielberkompas/ex_twilio/pull/66) ([danielberkompas](https://github.com/danielberkompas))
- typo: correct link to the documentation [\#64](https://github.com/danielberkompas/ex_twilio/pull/64) ([gliush](https://github.com/gliush))
- Add specifying outgoing client capability params [\#62](https://github.com/danielberkompas/ex_twilio/pull/62) ([brain-geek](https://github.com/brain-geek))
- Add caller\_name field to lookup [\#61](https://github.com/danielberkompas/ex_twilio/pull/61) ([he9lin](https://github.com/he9lin))
- Bump elixir version [\#60](https://github.com/danielberkompas/ex_twilio/pull/60) ([enilsen16](https://github.com/enilsen16))
- Implement Task Router API [\#55](https://github.com/danielberkompas/ex_twilio/pull/55) ([enilsen16](https://github.com/enilsen16))

## [v0.2.1](https://github.com/danielberkompas/ex_twilio/tree/v0.2.1) (2016-10-31)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.2.0...v0.2.1)

**Closed issues:**

- where is "Api.get!" defined? [\#48](https://github.com/danielberkompas/ex_twilio/issues/48)

**Merged pull requests:**

- Update joken, mock [\#58](https://github.com/danielberkompas/ex_twilio/pull/58) ([danielberkompas](https://github.com/danielberkompas))
- Add instructions for receiving a call in the calling tutorial [\#54](https://github.com/danielberkompas/ex_twilio/pull/54) ([joshuafleck](https://github.com/joshuafleck))
- Add lookup rest api [\#51](https://github.com/danielberkompas/ex_twilio/pull/51) ([enilsen16](https://github.com/enilsen16))
- Add capability tokens [\#50](https://github.com/danielberkompas/ex_twilio/pull/50) ([joshuafleck](https://github.com/joshuafleck))
- Make the recommended config exrm compatible [\#49](https://github.com/danielberkompas/ex_twilio/pull/49) ([jeffrafter](https://github.com/jeffrafter))
- Update notifications url \#46 [\#47](https://github.com/danielberkompas/ex_twilio/pull/47) ([Devinsuit](https://github.com/Devinsuit))

## [v0.2.0](https://github.com/danielberkompas/ex_twilio/tree/v0.2.0) (2016-07-20)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.9...v0.2.0)

**Merged pull requests:**

- Add Credo Linter [\#45](https://github.com/danielberkompas/ex_twilio/pull/45) ([danielberkompas](https://github.com/danielberkompas))
- Switch to HTTPoison [\#44](https://github.com/danielberkompas/ex_twilio/pull/44) ([danielberkompas](https://github.com/danielberkompas))

## [v0.1.9](https://github.com/danielberkompas/ex_twilio/tree/v0.1.9) (2016-07-02)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.8...v0.1.9)

**Closed issues:**

- Accessing the Usage logs [\#39](https://github.com/danielberkompas/ex_twilio/issues/39)
- Error on sending messages [\#36](https://github.com/danielberkompas/ex_twilio/issues/36)
- Add ability to create Capability tokens [\#28](https://github.com/danielberkompas/ex_twilio/issues/28)

**Merged pull requests:**

- Depend on Hex version of ibrowse [\#42](https://github.com/danielberkompas/ex_twilio/pull/42) ([danielberkompas](https://github.com/danielberkompas))
- This makes ex\_twilio compatible with elixir 1.3 [\#41](https://github.com/danielberkompas/ex_twilio/pull/41) ([tokafish](https://github.com/tokafish))

## [v0.1.8](https://github.com/danielberkompas/ex_twilio/tree/v0.1.8) (2016-06-06)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.7...v0.1.8)

**Closed issues:**

- Lack of domain when running ExTwilio.Call.all\(\) [\#38](https://github.com/danielberkompas/ex_twilio/issues/38)
- Hex dependency resolution issues [\#34](https://github.com/danielberkompas/ex_twilio/issues/34)
- ExTwilio.Message.create throws {:error, "The requested resource /2010-04-01/Messages.json was not found", 404} [\#33](https://github.com/danielberkompas/ex_twilio/issues/33)
- 2 Factor Authentication [\#32](https://github.com/danielberkompas/ex_twilio/issues/32)
- Switch out HTTPotion for Tesla? [\#10](https://github.com/danielberkompas/ex_twilio/issues/10)

**Merged pull requests:**

- Provide full url to process\_page when there is more than 50 entries. [\#40](https://github.com/danielberkompas/ex_twilio/pull/40) ([rlb3](https://github.com/rlb3))
- Remove unnecessary Utils module and replace its usages with Macro [\#35](https://github.com/danielberkompas/ex_twilio/pull/35) ([AvaelKross](https://github.com/AvaelKross))

## [v0.1.7](https://github.com/danielberkompas/ex_twilio/tree/v0.1.7) (2016-04-16)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.6...v0.1.7)

**Merged pull requests:**

- Fix Parser for Poison 2.0 [\#31](https://github.com/danielberkompas/ex_twilio/pull/31) ([danielberkompas](https://github.com/danielberkompas))

## [v0.1.6](https://github.com/danielberkompas/ex_twilio/tree/v0.1.6) (2016-04-16)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.5...v0.1.6)

## [v0.1.5](https://github.com/danielberkompas/ex_twilio/tree/v0.1.5) (2016-04-16)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.4...v0.1.5)

## [v0.1.4](https://github.com/danielberkompas/ex_twilio/tree/v0.1.4) (2016-03-29)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.3...v0.1.4)

**Closed issues:**

- Add TaskRouter support [\#27](https://github.com/danielberkompas/ex_twilio/issues/27)
- next\_page and etc implementation?  [\#23](https://github.com/danielberkompas/ex_twilio/issues/23)
- How can I use the Message module? [\#22](https://github.com/danielberkompas/ex_twilio/issues/22)

**Merged pull requests:**

- Upgrade Travis to Elixir 1.2 and OTP 18 [\#30](https://github.com/danielberkompas/ex_twilio/pull/30) ([danielberkompas](https://github.com/danielberkompas))
- Allow query strings to contain multiple values for a param [\#29](https://github.com/danielberkompas/ex_twilio/pull/29) ([brentonannan](https://github.com/brentonannan))
- add fixes for Elixir 1.2 compiler warnings [\#26](https://github.com/danielberkompas/ex_twilio/pull/26) ([jeffweiss](https://github.com/jeffweiss))
- adds required steps for installation [\#25](https://github.com/danielberkompas/ex_twilio/pull/25) ([AdamBrodzinski](https://github.com/AdamBrodzinski))
- Remove deleted functions from README [\#24](https://github.com/danielberkompas/ex_twilio/pull/24) ([danielberkompas](https://github.com/danielberkompas))

## [v0.1.3](https://github.com/danielberkompas/ex_twilio/tree/v0.1.3) (2015-10-08)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.2...v0.1.3)

**Closed issues:**

- Drop using `Mix.Utils` in runtime. [\#19](https://github.com/danielberkompas/ex_twilio/issues/19)

**Merged pull requests:**

- \[\#19\]: Stop using Mix.Utils [\#21](https://github.com/danielberkompas/ex_twilio/pull/21) ([danielberkompas](https://github.com/danielberkompas))
- Add missing applications to app template [\#20](https://github.com/danielberkompas/ex_twilio/pull/20) ([michalmuskala](https://github.com/michalmuskala))

## [v0.1.2](https://github.com/danielberkompas/ex_twilio/tree/v0.1.2) (2015-09-20)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.1...v0.1.2)

**Implemented enhancements:**

- Refactor `stream` function, remove list functions [\#14](https://github.com/danielberkompas/ex_twilio/pull/14) ([danielberkompas](https://github.com/danielberkompas))

**Merged pull requests:**

- Upgrade ExDoc [\#18](https://github.com/danielberkompas/ex_twilio/pull/18) ([danielberkompas](https://github.com/danielberkompas))
- Update release script [\#17](https://github.com/danielberkompas/ex_twilio/pull/17) ([danielberkompas](https://github.com/danielberkompas))
-  pin Poison dependency to \>= 1.4 and \< 2 [\#16](https://github.com/danielberkompas/ex_twilio/pull/16) ([jeffweiss](https://github.com/jeffweiss))
- Upgrade ibrowse dependency for R18 support [\#15](https://github.com/danielberkompas/ex_twilio/pull/15) ([nickcampbell18](https://github.com/nickcampbell18))

## [v0.1.1](https://github.com/danielberkompas/ex_twilio/tree/v0.1.1) (2015-05-22)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.1.0...v0.1.1)

## [v0.1.0](https://github.com/danielberkompas/ex_twilio/tree/v0.1.0) (2015-04-11)
[Full Changelog](https://github.com/danielberkompas/ex_twilio/compare/v0.0.1...v0.1.0)

**Implemented enhancements:**

- Support all Twilio API endpoints [\#9](https://github.com/danielberkompas/ex_twilio/issues/9)
- Simplify URL generation logic [\#4](https://github.com/danielberkompas/ex_twilio/issues/4)

**Closed issues:**

- Create tests for all Resource modules [\#3](https://github.com/danielberkompas/ex_twilio/issues/3)
- Add list of supported endpoints to README [\#2](https://github.com/danielberkompas/ex_twilio/issues/2)

**Merged pull requests:**

- Finish documenting and tests for now [\#12](https://github.com/danielberkompas/ex_twilio/pull/12) ([danielberkompas](https://github.com/danielberkompas))
- Support All Twilio REST Endpoints [\#11](https://github.com/danielberkompas/ex_twilio/pull/11) ([danielberkompas](https://github.com/danielberkompas))
- Reduce reliance on Enum [\#8](https://github.com/danielberkompas/ex_twilio/pull/8) ([danielberkompas](https://github.com/danielberkompas))
- \[\#4\] Rework URL generation [\#7](https://github.com/danielberkompas/ex_twilio/pull/7) ([danielberkompas](https://github.com/danielberkompas))
- Run Dialyzer on Travis CI [\#6](https://github.com/danielberkompas/ex_twilio/pull/6) ([danielberkompas](https://github.com/danielberkompas))

## [v0.0.1](https://github.com/danielberkompas/ex_twilio/tree/v0.0.1) (2015-03-31)
**Closed issues:**

- Update all inline documentation [\#1](https://github.com/danielberkompas/ex_twilio/issues/1)

**Merged pull requests:**

- Improve documentation and typespecs for all modules [\#5](https://github.com/danielberkompas/ex_twilio/pull/5) ([danielberkompas](https://github.com/danielberkompas))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*