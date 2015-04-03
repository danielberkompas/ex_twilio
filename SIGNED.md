##### Signed by https://keybase.io/dberkom
```
-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAABCgAGBQJVHydcAAoJEKU82t1CbYQMlusP/jH8yNML1j1HEJUTd2fdvuzy
JJk1dyXvDyUBjqh5GHY09aVs5D9NO1sHeby6Dx90yux/PVBMnczNrAOQSOpgh80n
HCncYD6/LjtINS314rBJIldmPDALlnghKO6Hig4XW1PAgz+EDD8ezh+SWdtEZ9vc
TJFgefB6bavqq84k2uLmIUh7QZA/siE1teLdYMTMQkwdNqRcWYQ2JY9mQ0+fMOhc
mo7LieIAiFi/kE/Ue7yyyiryqRimyZsAAgf9EcNgXA3lGeveF43fLD8fu6tYjSyr
oGIgo41eQ2AoeOTTDk5k+p68AhHPxfoiTbDEEaiyyBBhbQ3jVMqBzxDdO9CrAYlk
PstOAYlDAPSPTc65HQ+kirUC8lixg4yNLAKE7b1bN+r34079EhwI4gyBoYqw9Rys
PAUBga3EYMTq5Ciwn30bJok4SSF40A6XwVXkH5T+dHz8Gx64MKHHfWPqQgWOdkm9
0k2U284fz+SqMbZlptmCXmakOsDR2OYsWPbIHma6K6M44YjbLcscv2G2reDvR4nO
hf9PQlzwTkDVY4jKCBXIGmQ3EQBN464/Q5L/cMiIDxNso7aCnFa30jxgBs+C5MSb
UKTYxMSha3tFHqgrGr3bi7XRSHOxSCUixII8e59MPWqrEXQSU4huQwj0P/StjncG
xqIaEaYx18jp8/V9VwC6
=bx/c
-----END PGP SIGNATURE-----

```

<!-- END SIGNATURES -->

### Begin signed statement 

#### Expect

```
size   exec  file                               contents                                                        
             ./                                                                                                 
226            .env.sample                      3ffe8824962b877b97282a8490632f2cdb5e3beabb7b744da0a665b49ddfff69
44             .gitignore                       857886e5471b620284290fd034dbb7f70309a3df6ac085e46294ee0e307f7738
724            .travis.yml                      11e24d27bdcb29b5e4735918733fcdaeddbdcc582f13b71b0512d7c7834c5696
880            CHANGELOG.md                     225fd5169cf6b751ccfe6992e7bfd5cc8aab98879f98205b450d6b9cffaa8728
557            CONTRIBUTING.md                  371568cc5c19fce82d2954ba4740055400bde161224accb9ab6fee0a829dc1e9
1083           LICENSE                          a24b375a609f6c84e82c1458fbb0383678e3f492ffb83912731fa5313831a7c9
322            NOTICE                           9b9f53c89cde0e23ea4f718683e5f76d576d8129dc4a5b3d2597128bc61024ad
5574           README.md                        188636ae97c907587228df34a02f5e3884d5b21c1d2ac611685c10f6dc075fc3
               config/                                                                                          
169              config.exs                     bac83faf919bb771de3e6e31dea3fbebb836b5935fd0175a047de59e3e857a58
153              dev.exs                        191e78078937dec934f10dbd7e7e691af9b6df6e9fb7b4590f555590c8a04a4d
15               docs.exs                       93916c97d87a60564f1e10f03e407774c618a5349b41b7ed5bc1b6fae12f3e81
163              test.exs                       95167a5c5db8cf167e09405c30cd8c22be826f252bd52eb71b771cb957e83105
               lib/                                                                                             
                 ex_twilio/                                                                                     
13423              api.ex                       c01dbc9144f4a07bae19b16973caf390c0eadc7fbae9cbae41080c0a1f672f8d
1276               config.ex                    99f140f68282a401a66ea910e7b05c202e3843f32fe3a9f0f369d6bd9b4af228
3086               parser.ex                    3133422eedd288c085033ccc1961d9958a6f0dd68abc497c30e827f594fc2414
7748               resource.ex                  9cacadd8588f103ba864189049e7170423541de97d0cf4ad8ab1cbd49ab50f78
                   resources/                                                                                   
1901                 account.ex                 1b9c4fc0994d576be0da505b08cb0fd4ca4de42d87e70309c8d66ba4fe7ba9fd
506                  address.ex                 8c0d661e39cec4fcd598275177970e43669f5341984bce57aa21ad4282c14fe2
897                  application.ex             434f068ced4be6aa7cf0b9fbd81241c6b31f96fcc23afc1713b715ae6856ec4d
630                  authorized_connect_app.ex  6dfb631f604a8ba4c86df53830146344fe2b3247c6b3ab2aeabde72925d2e4fb
599                  available_phone_number.ex  0df57c4b08b3fa8e068dade7fcc7f211dc8d87fb02e5fbfd48707b13b0a963ac
1010                 call.ex                    90bf8250b0f4a528a2b0e94491a55e9187a05216c065027442e8950ded794565
440                  conference.ex              2c267af9bcfa4c3b4712a16915d6f2b612844fb7abccb4f9135a641f6d9d3312
687                  connect_app.ex             91ffbed58b76309ebec382b1e238fb26a6437c113b4234de9a0c427def641ae8
273                  dependent_phone_number.ex  266c96cea984f6ff65bf24fbd092ead644b2be22a42ec177c72b72b02ac2e3d4
293                  feedback.ex                a8ee125a72dd5596fff2811e053ffcf5b622c508b7f6d7ed9fbf4f7d01c3d8b6
1021                 incoming_phone_number.ex   535190e1f508a4bf3132f61a00a244fa7d1e3f363d29b5c9ba0fc00ae8071069
521                  media.ex                   162ccefe90bc96c4520e10e2298cf4b247bd308727c58631b3558746c28e0fe1
519                  member.ex                  461d23bb3033bd221214aded1d0747cc6506fb21c65560973c8b638f7d65038f
788                  message.ex                 9214ceabfca4be4d0cd1395acd264390eb64fa134e422a7d53301cc194307820
764                  notification.ex            f838a150493d27de184a515cb4000ffeb557e3aa574c43997a0dfad14e409743
556                  outgoing_caller_id.ex      65c1b4fdc3eadd887fc071d12d85b81336698be770b2c5a15f09b1593faa95d4
553                  participant.ex             ae0bcd65b8e76b17956c1b876487cd96c9c31f0303b1019612c4cef31658d3d3
409                  queue.ex                   c2a71b7fad9d925be176d05b2d7a5a1d5d7c6ba55a6d69c9447175eefa09557c
475                  recording.ex               882f8f55e6da1f4be12ee0df44c212a46a87f2c36ca427b2d510634b99275a7a
433                  token.ex                   bef92535bf91169de3a2254691b3ca0b06ceac3a4fbf2d60c0a448b2497be390
577                  transcription.ex           b0eefd5881048bf266925cd902f45d80f2480d7f39effeb9155d3aa231248fd7
386              ex_twilio.ex                   dadf12d2474b8e54317cc0a56bd658238bd67e1d9caa0a6d5778ec55cce57ce9
1337           mix.exs                          ebfb3781705342df841378405a8fd269b5a0cc80d383ff520664e5528bba0bae
720            mix.lock                         48ba2ef4f6bdeaf31e105f792ac653ca44d03ad50913758b5902ba12fa0fcc18
               test/                                                                                            
                 ex_twilio/                                                                                     
6854               api_test.exs                 3534944220bb3d219e50f2c01de36feacf72801718035efa89550de4cf57be0e
1234               parser_test.exs              41b4c2a172474c30572a12c41b05a1fb7873c0f4fd6d4464f8191c2df6f69281
3247               resource_test.exs            1c488020e67f5874a8692d8379386d7b72bcfbb21b7c1581262f6bdd7898bf83
                   resources/                                                                                   
15               test_helper.exs                b086ec47f0c6c7aaeb4cffca5ae5243dd05e0dc96ab761ced93325d5315f4b12
```

#### Ignore

```
/SIGNED.md
```

#### Presets

```
git      # ignore .git and anything as described by .gitignore files
dropbox  # ignore .dropbox-cache and other Dropbox-related files    
kb       # ignore anything as described by .kbignore files          
```

<!-- summarize version = 0.0.9 -->

### End signed statement

<hr>

#### Notes

With keybase you can sign any directory's contents, whether it's a git repo,
source code distribution, or a personal documents folder. It aims to replace the drudgery of:

  1. comparing a zipped file to a detached statement
  2. downloading a public key
  3. confirming it is in fact the author's by reviewing public statements they've made, using it

All in one simple command:

```bash
keybase dir verify
```

There are lots of options, including assertions for automating your checks.

For more info, check out https://keybase.io/docs/command_line/code_signing