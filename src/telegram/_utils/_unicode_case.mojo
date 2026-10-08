#!/usr/bin/env mojo
# Generated from CPython 3.11 Unicode case data for the PTB string helper.
"""Unicode case operations matching the pinned CPython reference behavior."""

def _lowercase_character(character: StringSlice) -> String:
    var codepoint = ord(character)
    if codepoint >= 65 and codepoint <= 90:
        return chr(codepoint + (32))
    if codepoint >= 192 and codepoint <= 214:
        return chr(codepoint + (32))
    if codepoint >= 216 and codepoint <= 222:
        return chr(codepoint + (32))
    if codepoint == 256:
        return chr(codepoint + (1))
    if codepoint == 258:
        return chr(codepoint + (1))
    if codepoint == 260:
        return chr(codepoint + (1))
    if codepoint == 262:
        return chr(codepoint + (1))
    if codepoint == 264:
        return chr(codepoint + (1))
    if codepoint == 266:
        return chr(codepoint + (1))
    if codepoint == 268:
        return chr(codepoint + (1))
    if codepoint == 270:
        return chr(codepoint + (1))
    if codepoint == 272:
        return chr(codepoint + (1))
    if codepoint == 274:
        return chr(codepoint + (1))
    if codepoint == 276:
        return chr(codepoint + (1))
    if codepoint == 278:
        return chr(codepoint + (1))
    if codepoint == 280:
        return chr(codepoint + (1))
    if codepoint == 282:
        return chr(codepoint + (1))
    if codepoint == 284:
        return chr(codepoint + (1))
    if codepoint == 286:
        return chr(codepoint + (1))
    if codepoint == 288:
        return chr(codepoint + (1))
    if codepoint == 290:
        return chr(codepoint + (1))
    if codepoint == 292:
        return chr(codepoint + (1))
    if codepoint == 294:
        return chr(codepoint + (1))
    if codepoint == 296:
        return chr(codepoint + (1))
    if codepoint == 298:
        return chr(codepoint + (1))
    if codepoint == 300:
        return chr(codepoint + (1))
    if codepoint == 302:
        return chr(codepoint + (1))
    if codepoint == 306:
        return chr(codepoint + (1))
    if codepoint == 308:
        return chr(codepoint + (1))
    if codepoint == 310:
        return chr(codepoint + (1))
    if codepoint == 313:
        return chr(codepoint + (1))
    if codepoint == 315:
        return chr(codepoint + (1))
    if codepoint == 317:
        return chr(codepoint + (1))
    if codepoint == 319:
        return chr(codepoint + (1))
    if codepoint == 321:
        return chr(codepoint + (1))
    if codepoint == 323:
        return chr(codepoint + (1))
    if codepoint == 325:
        return chr(codepoint + (1))
    if codepoint == 327:
        return chr(codepoint + (1))
    if codepoint == 330:
        return chr(codepoint + (1))
    if codepoint == 332:
        return chr(codepoint + (1))
    if codepoint == 334:
        return chr(codepoint + (1))
    if codepoint == 336:
        return chr(codepoint + (1))
    if codepoint == 338:
        return chr(codepoint + (1))
    if codepoint == 340:
        return chr(codepoint + (1))
    if codepoint == 342:
        return chr(codepoint + (1))
    if codepoint == 344:
        return chr(codepoint + (1))
    if codepoint == 346:
        return chr(codepoint + (1))
    if codepoint == 348:
        return chr(codepoint + (1))
    if codepoint == 350:
        return chr(codepoint + (1))
    if codepoint == 352:
        return chr(codepoint + (1))
    if codepoint == 354:
        return chr(codepoint + (1))
    if codepoint == 356:
        return chr(codepoint + (1))
    if codepoint == 358:
        return chr(codepoint + (1))
    if codepoint == 360:
        return chr(codepoint + (1))
    if codepoint == 362:
        return chr(codepoint + (1))
    if codepoint == 364:
        return chr(codepoint + (1))
    if codepoint == 366:
        return chr(codepoint + (1))
    if codepoint == 368:
        return chr(codepoint + (1))
    if codepoint == 370:
        return chr(codepoint + (1))
    if codepoint == 372:
        return chr(codepoint + (1))
    if codepoint == 374:
        return chr(codepoint + (1))
    if codepoint == 376:
        return chr(codepoint + (-121))
    if codepoint == 377:
        return chr(codepoint + (1))
    if codepoint == 379:
        return chr(codepoint + (1))
    if codepoint == 381:
        return chr(codepoint + (1))
    if codepoint == 385:
        return chr(codepoint + (210))
    if codepoint == 386:
        return chr(codepoint + (1))
    if codepoint == 388:
        return chr(codepoint + (1))
    if codepoint == 390:
        return chr(codepoint + (206))
    if codepoint == 391:
        return chr(codepoint + (1))
    if codepoint >= 393 and codepoint <= 394:
        return chr(codepoint + (205))
    if codepoint == 395:
        return chr(codepoint + (1))
    if codepoint == 398:
        return chr(codepoint + (79))
    if codepoint == 399:
        return chr(codepoint + (202))
    if codepoint == 400:
        return chr(codepoint + (203))
    if codepoint == 401:
        return chr(codepoint + (1))
    if codepoint == 403:
        return chr(codepoint + (205))
    if codepoint == 404:
        return chr(codepoint + (207))
    if codepoint == 406:
        return chr(codepoint + (211))
    if codepoint == 407:
        return chr(codepoint + (209))
    if codepoint == 408:
        return chr(codepoint + (1))
    if codepoint == 412:
        return chr(codepoint + (211))
    if codepoint == 413:
        return chr(codepoint + (213))
    if codepoint == 415:
        return chr(codepoint + (214))
    if codepoint == 416:
        return chr(codepoint + (1))
    if codepoint == 418:
        return chr(codepoint + (1))
    if codepoint == 420:
        return chr(codepoint + (1))
    if codepoint == 422:
        return chr(codepoint + (218))
    if codepoint == 423:
        return chr(codepoint + (1))
    if codepoint == 425:
        return chr(codepoint + (218))
    if codepoint == 428:
        return chr(codepoint + (1))
    if codepoint == 430:
        return chr(codepoint + (218))
    if codepoint == 431:
        return chr(codepoint + (1))
    if codepoint >= 433 and codepoint <= 434:
        return chr(codepoint + (217))
    if codepoint == 435:
        return chr(codepoint + (1))
    if codepoint == 437:
        return chr(codepoint + (1))
    if codepoint == 439:
        return chr(codepoint + (219))
    if codepoint == 440:
        return chr(codepoint + (1))
    if codepoint == 444:
        return chr(codepoint + (1))
    if codepoint == 452:
        return chr(codepoint + (2))
    if codepoint == 453:
        return chr(codepoint + (1))
    if codepoint == 455:
        return chr(codepoint + (2))
    if codepoint == 456:
        return chr(codepoint + (1))
    if codepoint == 458:
        return chr(codepoint + (2))
    if codepoint == 459:
        return chr(codepoint + (1))
    if codepoint == 461:
        return chr(codepoint + (1))
    if codepoint == 463:
        return chr(codepoint + (1))
    if codepoint == 465:
        return chr(codepoint + (1))
    if codepoint == 467:
        return chr(codepoint + (1))
    if codepoint == 469:
        return chr(codepoint + (1))
    if codepoint == 471:
        return chr(codepoint + (1))
    if codepoint == 473:
        return chr(codepoint + (1))
    if codepoint == 475:
        return chr(codepoint + (1))
    if codepoint == 478:
        return chr(codepoint + (1))
    if codepoint == 480:
        return chr(codepoint + (1))
    if codepoint == 482:
        return chr(codepoint + (1))
    if codepoint == 484:
        return chr(codepoint + (1))
    if codepoint == 486:
        return chr(codepoint + (1))
    if codepoint == 488:
        return chr(codepoint + (1))
    if codepoint == 490:
        return chr(codepoint + (1))
    if codepoint == 492:
        return chr(codepoint + (1))
    if codepoint == 494:
        return chr(codepoint + (1))
    if codepoint == 497:
        return chr(codepoint + (2))
    if codepoint == 498:
        return chr(codepoint + (1))
    if codepoint == 500:
        return chr(codepoint + (1))
    if codepoint == 502:
        return chr(codepoint + (-97))
    if codepoint == 503:
        return chr(codepoint + (-56))
    if codepoint == 504:
        return chr(codepoint + (1))
    if codepoint == 506:
        return chr(codepoint + (1))
    if codepoint == 508:
        return chr(codepoint + (1))
    if codepoint == 510:
        return chr(codepoint + (1))
    if codepoint == 512:
        return chr(codepoint + (1))
    if codepoint == 514:
        return chr(codepoint + (1))
    if codepoint == 516:
        return chr(codepoint + (1))
    if codepoint == 518:
        return chr(codepoint + (1))
    if codepoint == 520:
        return chr(codepoint + (1))
    if codepoint == 522:
        return chr(codepoint + (1))
    if codepoint == 524:
        return chr(codepoint + (1))
    if codepoint == 526:
        return chr(codepoint + (1))
    if codepoint == 528:
        return chr(codepoint + (1))
    if codepoint == 530:
        return chr(codepoint + (1))
    if codepoint == 532:
        return chr(codepoint + (1))
    if codepoint == 534:
        return chr(codepoint + (1))
    if codepoint == 536:
        return chr(codepoint + (1))
    if codepoint == 538:
        return chr(codepoint + (1))
    if codepoint == 540:
        return chr(codepoint + (1))
    if codepoint == 542:
        return chr(codepoint + (1))
    if codepoint == 544:
        return chr(codepoint + (-130))
    if codepoint == 546:
        return chr(codepoint + (1))
    if codepoint == 548:
        return chr(codepoint + (1))
    if codepoint == 550:
        return chr(codepoint + (1))
    if codepoint == 552:
        return chr(codepoint + (1))
    if codepoint == 554:
        return chr(codepoint + (1))
    if codepoint == 556:
        return chr(codepoint + (1))
    if codepoint == 558:
        return chr(codepoint + (1))
    if codepoint == 560:
        return chr(codepoint + (1))
    if codepoint == 562:
        return chr(codepoint + (1))
    if codepoint == 570:
        return chr(codepoint + (10795))
    if codepoint == 571:
        return chr(codepoint + (1))
    if codepoint == 573:
        return chr(codepoint + (-163))
    if codepoint == 574:
        return chr(codepoint + (10792))
    if codepoint == 577:
        return chr(codepoint + (1))
    if codepoint == 579:
        return chr(codepoint + (-195))
    if codepoint == 580:
        return chr(codepoint + (69))
    if codepoint == 581:
        return chr(codepoint + (71))
    if codepoint == 582:
        return chr(codepoint + (1))
    if codepoint == 584:
        return chr(codepoint + (1))
    if codepoint == 586:
        return chr(codepoint + (1))
    if codepoint == 588:
        return chr(codepoint + (1))
    if codepoint == 590:
        return chr(codepoint + (1))
    if codepoint == 880:
        return chr(codepoint + (1))
    if codepoint == 882:
        return chr(codepoint + (1))
    if codepoint == 886:
        return chr(codepoint + (1))
    if codepoint == 895:
        return chr(codepoint + (116))
    if codepoint == 902:
        return chr(codepoint + (38))
    if codepoint >= 904 and codepoint <= 906:
        return chr(codepoint + (37))
    if codepoint == 908:
        return chr(codepoint + (64))
    if codepoint >= 910 and codepoint <= 911:
        return chr(codepoint + (63))
    if codepoint >= 913 and codepoint <= 929:
        return chr(codepoint + (32))
    if codepoint >= 931 and codepoint <= 939:
        return chr(codepoint + (32))
    if codepoint == 975:
        return chr(codepoint + (8))
    if codepoint == 984:
        return chr(codepoint + (1))
    if codepoint == 986:
        return chr(codepoint + (1))
    if codepoint == 988:
        return chr(codepoint + (1))
    if codepoint == 990:
        return chr(codepoint + (1))
    if codepoint == 992:
        return chr(codepoint + (1))
    if codepoint == 994:
        return chr(codepoint + (1))
    if codepoint == 996:
        return chr(codepoint + (1))
    if codepoint == 998:
        return chr(codepoint + (1))
    if codepoint == 1000:
        return chr(codepoint + (1))
    if codepoint == 1002:
        return chr(codepoint + (1))
    if codepoint == 1004:
        return chr(codepoint + (1))
    if codepoint == 1006:
        return chr(codepoint + (1))
    if codepoint == 1012:
        return chr(codepoint + (-60))
    if codepoint == 1015:
        return chr(codepoint + (1))
    if codepoint == 1017:
        return chr(codepoint + (-7))
    if codepoint == 1018:
        return chr(codepoint + (1))
    if codepoint >= 1021 and codepoint <= 1023:
        return chr(codepoint + (-130))
    if codepoint >= 1024 and codepoint <= 1039:
        return chr(codepoint + (80))
    if codepoint >= 1040 and codepoint <= 1071:
        return chr(codepoint + (32))
    if codepoint == 1120:
        return chr(codepoint + (1))
    if codepoint == 1122:
        return chr(codepoint + (1))
    if codepoint == 1124:
        return chr(codepoint + (1))
    if codepoint == 1126:
        return chr(codepoint + (1))
    if codepoint == 1128:
        return chr(codepoint + (1))
    if codepoint == 1130:
        return chr(codepoint + (1))
    if codepoint == 1132:
        return chr(codepoint + (1))
    if codepoint == 1134:
        return chr(codepoint + (1))
    if codepoint == 1136:
        return chr(codepoint + (1))
    if codepoint == 1138:
        return chr(codepoint + (1))
    if codepoint == 1140:
        return chr(codepoint + (1))
    if codepoint == 1142:
        return chr(codepoint + (1))
    if codepoint == 1144:
        return chr(codepoint + (1))
    if codepoint == 1146:
        return chr(codepoint + (1))
    if codepoint == 1148:
        return chr(codepoint + (1))
    if codepoint == 1150:
        return chr(codepoint + (1))
    if codepoint == 1152:
        return chr(codepoint + (1))
    if codepoint == 1162:
        return chr(codepoint + (1))
    if codepoint == 1164:
        return chr(codepoint + (1))
    if codepoint == 1166:
        return chr(codepoint + (1))
    if codepoint == 1168:
        return chr(codepoint + (1))
    if codepoint == 1170:
        return chr(codepoint + (1))
    if codepoint == 1172:
        return chr(codepoint + (1))
    if codepoint == 1174:
        return chr(codepoint + (1))
    if codepoint == 1176:
        return chr(codepoint + (1))
    if codepoint == 1178:
        return chr(codepoint + (1))
    if codepoint == 1180:
        return chr(codepoint + (1))
    if codepoint == 1182:
        return chr(codepoint + (1))
    if codepoint == 1184:
        return chr(codepoint + (1))
    if codepoint == 1186:
        return chr(codepoint + (1))
    if codepoint == 1188:
        return chr(codepoint + (1))
    if codepoint == 1190:
        return chr(codepoint + (1))
    if codepoint == 1192:
        return chr(codepoint + (1))
    if codepoint == 1194:
        return chr(codepoint + (1))
    if codepoint == 1196:
        return chr(codepoint + (1))
    if codepoint == 1198:
        return chr(codepoint + (1))
    if codepoint == 1200:
        return chr(codepoint + (1))
    if codepoint == 1202:
        return chr(codepoint + (1))
    if codepoint == 1204:
        return chr(codepoint + (1))
    if codepoint == 1206:
        return chr(codepoint + (1))
    if codepoint == 1208:
        return chr(codepoint + (1))
    if codepoint == 1210:
        return chr(codepoint + (1))
    if codepoint == 1212:
        return chr(codepoint + (1))
    if codepoint == 1214:
        return chr(codepoint + (1))
    if codepoint == 1216:
        return chr(codepoint + (15))
    if codepoint == 1217:
        return chr(codepoint + (1))
    if codepoint == 1219:
        return chr(codepoint + (1))
    if codepoint == 1221:
        return chr(codepoint + (1))
    if codepoint == 1223:
        return chr(codepoint + (1))
    if codepoint == 1225:
        return chr(codepoint + (1))
    if codepoint == 1227:
        return chr(codepoint + (1))
    if codepoint == 1229:
        return chr(codepoint + (1))
    if codepoint == 1232:
        return chr(codepoint + (1))
    if codepoint == 1234:
        return chr(codepoint + (1))
    if codepoint == 1236:
        return chr(codepoint + (1))
    if codepoint == 1238:
        return chr(codepoint + (1))
    if codepoint == 1240:
        return chr(codepoint + (1))
    if codepoint == 1242:
        return chr(codepoint + (1))
    if codepoint == 1244:
        return chr(codepoint + (1))
    if codepoint == 1246:
        return chr(codepoint + (1))
    if codepoint == 1248:
        return chr(codepoint + (1))
    if codepoint == 1250:
        return chr(codepoint + (1))
    if codepoint == 1252:
        return chr(codepoint + (1))
    if codepoint == 1254:
        return chr(codepoint + (1))
    if codepoint == 1256:
        return chr(codepoint + (1))
    if codepoint == 1258:
        return chr(codepoint + (1))
    if codepoint == 1260:
        return chr(codepoint + (1))
    if codepoint == 1262:
        return chr(codepoint + (1))
    if codepoint == 1264:
        return chr(codepoint + (1))
    if codepoint == 1266:
        return chr(codepoint + (1))
    if codepoint == 1268:
        return chr(codepoint + (1))
    if codepoint == 1270:
        return chr(codepoint + (1))
    if codepoint == 1272:
        return chr(codepoint + (1))
    if codepoint == 1274:
        return chr(codepoint + (1))
    if codepoint == 1276:
        return chr(codepoint + (1))
    if codepoint == 1278:
        return chr(codepoint + (1))
    if codepoint == 1280:
        return chr(codepoint + (1))
    if codepoint == 1282:
        return chr(codepoint + (1))
    if codepoint == 1284:
        return chr(codepoint + (1))
    if codepoint == 1286:
        return chr(codepoint + (1))
    if codepoint == 1288:
        return chr(codepoint + (1))
    if codepoint == 1290:
        return chr(codepoint + (1))
    if codepoint == 1292:
        return chr(codepoint + (1))
    if codepoint == 1294:
        return chr(codepoint + (1))
    if codepoint == 1296:
        return chr(codepoint + (1))
    if codepoint == 1298:
        return chr(codepoint + (1))
    if codepoint == 1300:
        return chr(codepoint + (1))
    if codepoint == 1302:
        return chr(codepoint + (1))
    if codepoint == 1304:
        return chr(codepoint + (1))
    if codepoint == 1306:
        return chr(codepoint + (1))
    if codepoint == 1308:
        return chr(codepoint + (1))
    if codepoint == 1310:
        return chr(codepoint + (1))
    if codepoint == 1312:
        return chr(codepoint + (1))
    if codepoint == 1314:
        return chr(codepoint + (1))
    if codepoint == 1316:
        return chr(codepoint + (1))
    if codepoint == 1318:
        return chr(codepoint + (1))
    if codepoint == 1320:
        return chr(codepoint + (1))
    if codepoint == 1322:
        return chr(codepoint + (1))
    if codepoint == 1324:
        return chr(codepoint + (1))
    if codepoint == 1326:
        return chr(codepoint + (1))
    if codepoint >= 1329 and codepoint <= 1366:
        return chr(codepoint + (48))
    if codepoint >= 4256 and codepoint <= 4293:
        return chr(codepoint + (7264))
    if codepoint == 4295:
        return chr(codepoint + (7264))
    if codepoint == 4301:
        return chr(codepoint + (7264))
    if codepoint >= 5024 and codepoint <= 5103:
        return chr(codepoint + (38864))
    if codepoint >= 5104 and codepoint <= 5109:
        return chr(codepoint + (8))
    if codepoint >= 7312 and codepoint <= 7354:
        return chr(codepoint + (-3008))
    if codepoint >= 7357 and codepoint <= 7359:
        return chr(codepoint + (-3008))
    if codepoint == 7680:
        return chr(codepoint + (1))
    if codepoint == 7682:
        return chr(codepoint + (1))
    if codepoint == 7684:
        return chr(codepoint + (1))
    if codepoint == 7686:
        return chr(codepoint + (1))
    if codepoint == 7688:
        return chr(codepoint + (1))
    if codepoint == 7690:
        return chr(codepoint + (1))
    if codepoint == 7692:
        return chr(codepoint + (1))
    if codepoint == 7694:
        return chr(codepoint + (1))
    if codepoint == 7696:
        return chr(codepoint + (1))
    if codepoint == 7698:
        return chr(codepoint + (1))
    if codepoint == 7700:
        return chr(codepoint + (1))
    if codepoint == 7702:
        return chr(codepoint + (1))
    if codepoint == 7704:
        return chr(codepoint + (1))
    if codepoint == 7706:
        return chr(codepoint + (1))
    if codepoint == 7708:
        return chr(codepoint + (1))
    if codepoint == 7710:
        return chr(codepoint + (1))
    if codepoint == 7712:
        return chr(codepoint + (1))
    if codepoint == 7714:
        return chr(codepoint + (1))
    if codepoint == 7716:
        return chr(codepoint + (1))
    if codepoint == 7718:
        return chr(codepoint + (1))
    if codepoint == 7720:
        return chr(codepoint + (1))
    if codepoint == 7722:
        return chr(codepoint + (1))
    if codepoint == 7724:
        return chr(codepoint + (1))
    if codepoint == 7726:
        return chr(codepoint + (1))
    if codepoint == 7728:
        return chr(codepoint + (1))
    if codepoint == 7730:
        return chr(codepoint + (1))
    if codepoint == 7732:
        return chr(codepoint + (1))
    if codepoint == 7734:
        return chr(codepoint + (1))
    if codepoint == 7736:
        return chr(codepoint + (1))
    if codepoint == 7738:
        return chr(codepoint + (1))
    if codepoint == 7740:
        return chr(codepoint + (1))
    if codepoint == 7742:
        return chr(codepoint + (1))
    if codepoint == 7744:
        return chr(codepoint + (1))
    if codepoint == 7746:
        return chr(codepoint + (1))
    if codepoint == 7748:
        return chr(codepoint + (1))
    if codepoint == 7750:
        return chr(codepoint + (1))
    if codepoint == 7752:
        return chr(codepoint + (1))
    if codepoint == 7754:
        return chr(codepoint + (1))
    if codepoint == 7756:
        return chr(codepoint + (1))
    if codepoint == 7758:
        return chr(codepoint + (1))
    if codepoint == 7760:
        return chr(codepoint + (1))
    if codepoint == 7762:
        return chr(codepoint + (1))
    if codepoint == 7764:
        return chr(codepoint + (1))
    if codepoint == 7766:
        return chr(codepoint + (1))
    if codepoint == 7768:
        return chr(codepoint + (1))
    if codepoint == 7770:
        return chr(codepoint + (1))
    if codepoint == 7772:
        return chr(codepoint + (1))
    if codepoint == 7774:
        return chr(codepoint + (1))
    if codepoint == 7776:
        return chr(codepoint + (1))
    if codepoint == 7778:
        return chr(codepoint + (1))
    if codepoint == 7780:
        return chr(codepoint + (1))
    if codepoint == 7782:
        return chr(codepoint + (1))
    if codepoint == 7784:
        return chr(codepoint + (1))
    if codepoint == 7786:
        return chr(codepoint + (1))
    if codepoint == 7788:
        return chr(codepoint + (1))
    if codepoint == 7790:
        return chr(codepoint + (1))
    if codepoint == 7792:
        return chr(codepoint + (1))
    if codepoint == 7794:
        return chr(codepoint + (1))
    if codepoint == 7796:
        return chr(codepoint + (1))
    if codepoint == 7798:
        return chr(codepoint + (1))
    if codepoint == 7800:
        return chr(codepoint + (1))
    if codepoint == 7802:
        return chr(codepoint + (1))
    if codepoint == 7804:
        return chr(codepoint + (1))
    if codepoint == 7806:
        return chr(codepoint + (1))
    if codepoint == 7808:
        return chr(codepoint + (1))
    if codepoint == 7810:
        return chr(codepoint + (1))
    if codepoint == 7812:
        return chr(codepoint + (1))
    if codepoint == 7814:
        return chr(codepoint + (1))
    if codepoint == 7816:
        return chr(codepoint + (1))
    if codepoint == 7818:
        return chr(codepoint + (1))
    if codepoint == 7820:
        return chr(codepoint + (1))
    if codepoint == 7822:
        return chr(codepoint + (1))
    if codepoint == 7824:
        return chr(codepoint + (1))
    if codepoint == 7826:
        return chr(codepoint + (1))
    if codepoint == 7828:
        return chr(codepoint + (1))
    if codepoint == 7838:
        return chr(codepoint + (-7615))
    if codepoint == 7840:
        return chr(codepoint + (1))
    if codepoint == 7842:
        return chr(codepoint + (1))
    if codepoint == 7844:
        return chr(codepoint + (1))
    if codepoint == 7846:
        return chr(codepoint + (1))
    if codepoint == 7848:
        return chr(codepoint + (1))
    if codepoint == 7850:
        return chr(codepoint + (1))
    if codepoint == 7852:
        return chr(codepoint + (1))
    if codepoint == 7854:
        return chr(codepoint + (1))
    if codepoint == 7856:
        return chr(codepoint + (1))
    if codepoint == 7858:
        return chr(codepoint + (1))
    if codepoint == 7860:
        return chr(codepoint + (1))
    if codepoint == 7862:
        return chr(codepoint + (1))
    if codepoint == 7864:
        return chr(codepoint + (1))
    if codepoint == 7866:
        return chr(codepoint + (1))
    if codepoint == 7868:
        return chr(codepoint + (1))
    if codepoint == 7870:
        return chr(codepoint + (1))
    if codepoint == 7872:
        return chr(codepoint + (1))
    if codepoint == 7874:
        return chr(codepoint + (1))
    if codepoint == 7876:
        return chr(codepoint + (1))
    if codepoint == 7878:
        return chr(codepoint + (1))
    if codepoint == 7880:
        return chr(codepoint + (1))
    if codepoint == 7882:
        return chr(codepoint + (1))
    if codepoint == 7884:
        return chr(codepoint + (1))
    if codepoint == 7886:
        return chr(codepoint + (1))
    if codepoint == 7888:
        return chr(codepoint + (1))
    if codepoint == 7890:
        return chr(codepoint + (1))
    if codepoint == 7892:
        return chr(codepoint + (1))
    if codepoint == 7894:
        return chr(codepoint + (1))
    if codepoint == 7896:
        return chr(codepoint + (1))
    if codepoint == 7898:
        return chr(codepoint + (1))
    if codepoint == 7900:
        return chr(codepoint + (1))
    if codepoint == 7902:
        return chr(codepoint + (1))
    if codepoint == 7904:
        return chr(codepoint + (1))
    if codepoint == 7906:
        return chr(codepoint + (1))
    if codepoint == 7908:
        return chr(codepoint + (1))
    if codepoint == 7910:
        return chr(codepoint + (1))
    if codepoint == 7912:
        return chr(codepoint + (1))
    if codepoint == 7914:
        return chr(codepoint + (1))
    if codepoint == 7916:
        return chr(codepoint + (1))
    if codepoint == 7918:
        return chr(codepoint + (1))
    if codepoint == 7920:
        return chr(codepoint + (1))
    if codepoint == 7922:
        return chr(codepoint + (1))
    if codepoint == 7924:
        return chr(codepoint + (1))
    if codepoint == 7926:
        return chr(codepoint + (1))
    if codepoint == 7928:
        return chr(codepoint + (1))
    if codepoint == 7930:
        return chr(codepoint + (1))
    if codepoint == 7932:
        return chr(codepoint + (1))
    if codepoint == 7934:
        return chr(codepoint + (1))
    if codepoint >= 7944 and codepoint <= 7951:
        return chr(codepoint + (-8))
    if codepoint >= 7960 and codepoint <= 7965:
        return chr(codepoint + (-8))
    if codepoint >= 7976 and codepoint <= 7983:
        return chr(codepoint + (-8))
    if codepoint >= 7992 and codepoint <= 7999:
        return chr(codepoint + (-8))
    if codepoint >= 8008 and codepoint <= 8013:
        return chr(codepoint + (-8))
    if codepoint == 8025:
        return chr(codepoint + (-8))
    if codepoint == 8027:
        return chr(codepoint + (-8))
    if codepoint == 8029:
        return chr(codepoint + (-8))
    if codepoint == 8031:
        return chr(codepoint + (-8))
    if codepoint >= 8040 and codepoint <= 8047:
        return chr(codepoint + (-8))
    if codepoint >= 8072 and codepoint <= 8079:
        return chr(codepoint + (-8))
    if codepoint >= 8088 and codepoint <= 8095:
        return chr(codepoint + (-8))
    if codepoint >= 8104 and codepoint <= 8111:
        return chr(codepoint + (-8))
    if codepoint >= 8120 and codepoint <= 8121:
        return chr(codepoint + (-8))
    if codepoint >= 8122 and codepoint <= 8123:
        return chr(codepoint + (-74))
    if codepoint == 8124:
        return chr(codepoint + (-9))
    if codepoint >= 8136 and codepoint <= 8139:
        return chr(codepoint + (-86))
    if codepoint == 8140:
        return chr(codepoint + (-9))
    if codepoint >= 8152 and codepoint <= 8153:
        return chr(codepoint + (-8))
    if codepoint >= 8154 and codepoint <= 8155:
        return chr(codepoint + (-100))
    if codepoint >= 8168 and codepoint <= 8169:
        return chr(codepoint + (-8))
    if codepoint >= 8170 and codepoint <= 8171:
        return chr(codepoint + (-112))
    if codepoint == 8172:
        return chr(codepoint + (-7))
    if codepoint >= 8184 and codepoint <= 8185:
        return chr(codepoint + (-128))
    if codepoint >= 8186 and codepoint <= 8187:
        return chr(codepoint + (-126))
    if codepoint == 8188:
        return chr(codepoint + (-9))
    if codepoint == 8486:
        return chr(codepoint + (-7517))
    if codepoint == 8490:
        return chr(codepoint + (-8383))
    if codepoint == 8491:
        return chr(codepoint + (-8262))
    if codepoint == 8498:
        return chr(codepoint + (28))
    if codepoint >= 8544 and codepoint <= 8559:
        return chr(codepoint + (16))
    if codepoint == 8579:
        return chr(codepoint + (1))
    if codepoint >= 9398 and codepoint <= 9423:
        return chr(codepoint + (26))
    if codepoint >= 11264 and codepoint <= 11311:
        return chr(codepoint + (48))
    if codepoint == 11360:
        return chr(codepoint + (1))
    if codepoint == 11362:
        return chr(codepoint + (-10743))
    if codepoint == 11363:
        return chr(codepoint + (-3814))
    if codepoint == 11364:
        return chr(codepoint + (-10727))
    if codepoint == 11367:
        return chr(codepoint + (1))
    if codepoint == 11369:
        return chr(codepoint + (1))
    if codepoint == 11371:
        return chr(codepoint + (1))
    if codepoint == 11373:
        return chr(codepoint + (-10780))
    if codepoint == 11374:
        return chr(codepoint + (-10749))
    if codepoint == 11375:
        return chr(codepoint + (-10783))
    if codepoint == 11376:
        return chr(codepoint + (-10782))
    if codepoint == 11378:
        return chr(codepoint + (1))
    if codepoint == 11381:
        return chr(codepoint + (1))
    if codepoint >= 11390 and codepoint <= 11391:
        return chr(codepoint + (-10815))
    if codepoint == 11392:
        return chr(codepoint + (1))
    if codepoint == 11394:
        return chr(codepoint + (1))
    if codepoint == 11396:
        return chr(codepoint + (1))
    if codepoint == 11398:
        return chr(codepoint + (1))
    if codepoint == 11400:
        return chr(codepoint + (1))
    if codepoint == 11402:
        return chr(codepoint + (1))
    if codepoint == 11404:
        return chr(codepoint + (1))
    if codepoint == 11406:
        return chr(codepoint + (1))
    if codepoint == 11408:
        return chr(codepoint + (1))
    if codepoint == 11410:
        return chr(codepoint + (1))
    if codepoint == 11412:
        return chr(codepoint + (1))
    if codepoint == 11414:
        return chr(codepoint + (1))
    if codepoint == 11416:
        return chr(codepoint + (1))
    if codepoint == 11418:
        return chr(codepoint + (1))
    if codepoint == 11420:
        return chr(codepoint + (1))
    if codepoint == 11422:
        return chr(codepoint + (1))
    if codepoint == 11424:
        return chr(codepoint + (1))
    if codepoint == 11426:
        return chr(codepoint + (1))
    if codepoint == 11428:
        return chr(codepoint + (1))
    if codepoint == 11430:
        return chr(codepoint + (1))
    if codepoint == 11432:
        return chr(codepoint + (1))
    if codepoint == 11434:
        return chr(codepoint + (1))
    if codepoint == 11436:
        return chr(codepoint + (1))
    if codepoint == 11438:
        return chr(codepoint + (1))
    if codepoint == 11440:
        return chr(codepoint + (1))
    if codepoint == 11442:
        return chr(codepoint + (1))
    if codepoint == 11444:
        return chr(codepoint + (1))
    if codepoint == 11446:
        return chr(codepoint + (1))
    if codepoint == 11448:
        return chr(codepoint + (1))
    if codepoint == 11450:
        return chr(codepoint + (1))
    if codepoint == 11452:
        return chr(codepoint + (1))
    if codepoint == 11454:
        return chr(codepoint + (1))
    if codepoint == 11456:
        return chr(codepoint + (1))
    if codepoint == 11458:
        return chr(codepoint + (1))
    if codepoint == 11460:
        return chr(codepoint + (1))
    if codepoint == 11462:
        return chr(codepoint + (1))
    if codepoint == 11464:
        return chr(codepoint + (1))
    if codepoint == 11466:
        return chr(codepoint + (1))
    if codepoint == 11468:
        return chr(codepoint + (1))
    if codepoint == 11470:
        return chr(codepoint + (1))
    if codepoint == 11472:
        return chr(codepoint + (1))
    if codepoint == 11474:
        return chr(codepoint + (1))
    if codepoint == 11476:
        return chr(codepoint + (1))
    if codepoint == 11478:
        return chr(codepoint + (1))
    if codepoint == 11480:
        return chr(codepoint + (1))
    if codepoint == 11482:
        return chr(codepoint + (1))
    if codepoint == 11484:
        return chr(codepoint + (1))
    if codepoint == 11486:
        return chr(codepoint + (1))
    if codepoint == 11488:
        return chr(codepoint + (1))
    if codepoint == 11490:
        return chr(codepoint + (1))
    if codepoint == 11499:
        return chr(codepoint + (1))
    if codepoint == 11501:
        return chr(codepoint + (1))
    if codepoint == 11506:
        return chr(codepoint + (1))
    if codepoint == 42560:
        return chr(codepoint + (1))
    if codepoint == 42562:
        return chr(codepoint + (1))
    if codepoint == 42564:
        return chr(codepoint + (1))
    if codepoint == 42566:
        return chr(codepoint + (1))
    if codepoint == 42568:
        return chr(codepoint + (1))
    if codepoint == 42570:
        return chr(codepoint + (1))
    if codepoint == 42572:
        return chr(codepoint + (1))
    if codepoint == 42574:
        return chr(codepoint + (1))
    if codepoint == 42576:
        return chr(codepoint + (1))
    if codepoint == 42578:
        return chr(codepoint + (1))
    if codepoint == 42580:
        return chr(codepoint + (1))
    if codepoint == 42582:
        return chr(codepoint + (1))
    if codepoint == 42584:
        return chr(codepoint + (1))
    if codepoint == 42586:
        return chr(codepoint + (1))
    if codepoint == 42588:
        return chr(codepoint + (1))
    if codepoint == 42590:
        return chr(codepoint + (1))
    if codepoint == 42592:
        return chr(codepoint + (1))
    if codepoint == 42594:
        return chr(codepoint + (1))
    if codepoint == 42596:
        return chr(codepoint + (1))
    if codepoint == 42598:
        return chr(codepoint + (1))
    if codepoint == 42600:
        return chr(codepoint + (1))
    if codepoint == 42602:
        return chr(codepoint + (1))
    if codepoint == 42604:
        return chr(codepoint + (1))
    if codepoint == 42624:
        return chr(codepoint + (1))
    if codepoint == 42626:
        return chr(codepoint + (1))
    if codepoint == 42628:
        return chr(codepoint + (1))
    if codepoint == 42630:
        return chr(codepoint + (1))
    if codepoint == 42632:
        return chr(codepoint + (1))
    if codepoint == 42634:
        return chr(codepoint + (1))
    if codepoint == 42636:
        return chr(codepoint + (1))
    if codepoint == 42638:
        return chr(codepoint + (1))
    if codepoint == 42640:
        return chr(codepoint + (1))
    if codepoint == 42642:
        return chr(codepoint + (1))
    if codepoint == 42644:
        return chr(codepoint + (1))
    if codepoint == 42646:
        return chr(codepoint + (1))
    if codepoint == 42648:
        return chr(codepoint + (1))
    if codepoint == 42650:
        return chr(codepoint + (1))
    if codepoint == 42786:
        return chr(codepoint + (1))
    if codepoint == 42788:
        return chr(codepoint + (1))
    if codepoint == 42790:
        return chr(codepoint + (1))
    if codepoint == 42792:
        return chr(codepoint + (1))
    if codepoint == 42794:
        return chr(codepoint + (1))
    if codepoint == 42796:
        return chr(codepoint + (1))
    if codepoint == 42798:
        return chr(codepoint + (1))
    if codepoint == 42802:
        return chr(codepoint + (1))
    if codepoint == 42804:
        return chr(codepoint + (1))
    if codepoint == 42806:
        return chr(codepoint + (1))
    if codepoint == 42808:
        return chr(codepoint + (1))
    if codepoint == 42810:
        return chr(codepoint + (1))
    if codepoint == 42812:
        return chr(codepoint + (1))
    if codepoint == 42814:
        return chr(codepoint + (1))
    if codepoint == 42816:
        return chr(codepoint + (1))
    if codepoint == 42818:
        return chr(codepoint + (1))
    if codepoint == 42820:
        return chr(codepoint + (1))
    if codepoint == 42822:
        return chr(codepoint + (1))
    if codepoint == 42824:
        return chr(codepoint + (1))
    if codepoint == 42826:
        return chr(codepoint + (1))
    if codepoint == 42828:
        return chr(codepoint + (1))
    if codepoint == 42830:
        return chr(codepoint + (1))
    if codepoint == 42832:
        return chr(codepoint + (1))
    if codepoint == 42834:
        return chr(codepoint + (1))
    if codepoint == 42836:
        return chr(codepoint + (1))
    if codepoint == 42838:
        return chr(codepoint + (1))
    if codepoint == 42840:
        return chr(codepoint + (1))
    if codepoint == 42842:
        return chr(codepoint + (1))
    if codepoint == 42844:
        return chr(codepoint + (1))
    if codepoint == 42846:
        return chr(codepoint + (1))
    if codepoint == 42848:
        return chr(codepoint + (1))
    if codepoint == 42850:
        return chr(codepoint + (1))
    if codepoint == 42852:
        return chr(codepoint + (1))
    if codepoint == 42854:
        return chr(codepoint + (1))
    if codepoint == 42856:
        return chr(codepoint + (1))
    if codepoint == 42858:
        return chr(codepoint + (1))
    if codepoint == 42860:
        return chr(codepoint + (1))
    if codepoint == 42862:
        return chr(codepoint + (1))
    if codepoint == 42873:
        return chr(codepoint + (1))
    if codepoint == 42875:
        return chr(codepoint + (1))
    if codepoint == 42877:
        return chr(codepoint + (-35332))
    if codepoint == 42878:
        return chr(codepoint + (1))
    if codepoint == 42880:
        return chr(codepoint + (1))
    if codepoint == 42882:
        return chr(codepoint + (1))
    if codepoint == 42884:
        return chr(codepoint + (1))
    if codepoint == 42886:
        return chr(codepoint + (1))
    if codepoint == 42891:
        return chr(codepoint + (1))
    if codepoint == 42893:
        return chr(codepoint + (-42280))
    if codepoint == 42896:
        return chr(codepoint + (1))
    if codepoint == 42898:
        return chr(codepoint + (1))
    if codepoint == 42902:
        return chr(codepoint + (1))
    if codepoint == 42904:
        return chr(codepoint + (1))
    if codepoint == 42906:
        return chr(codepoint + (1))
    if codepoint == 42908:
        return chr(codepoint + (1))
    if codepoint == 42910:
        return chr(codepoint + (1))
    if codepoint == 42912:
        return chr(codepoint + (1))
    if codepoint == 42914:
        return chr(codepoint + (1))
    if codepoint == 42916:
        return chr(codepoint + (1))
    if codepoint == 42918:
        return chr(codepoint + (1))
    if codepoint == 42920:
        return chr(codepoint + (1))
    if codepoint == 42922:
        return chr(codepoint + (-42308))
    if codepoint == 42923:
        return chr(codepoint + (-42319))
    if codepoint == 42924:
        return chr(codepoint + (-42315))
    if codepoint == 42925:
        return chr(codepoint + (-42305))
    if codepoint == 42926:
        return chr(codepoint + (-42308))
    if codepoint == 42928:
        return chr(codepoint + (-42258))
    if codepoint == 42929:
        return chr(codepoint + (-42282))
    if codepoint == 42930:
        return chr(codepoint + (-42261))
    if codepoint == 42931:
        return chr(codepoint + (928))
    if codepoint == 42932:
        return chr(codepoint + (1))
    if codepoint == 42934:
        return chr(codepoint + (1))
    if codepoint == 42936:
        return chr(codepoint + (1))
    if codepoint == 42938:
        return chr(codepoint + (1))
    if codepoint == 42940:
        return chr(codepoint + (1))
    if codepoint == 42942:
        return chr(codepoint + (1))
    if codepoint == 42944:
        return chr(codepoint + (1))
    if codepoint == 42946:
        return chr(codepoint + (1))
    if codepoint == 42948:
        return chr(codepoint + (-48))
    if codepoint == 42949:
        return chr(codepoint + (-42307))
    if codepoint == 42950:
        return chr(codepoint + (-35384))
    if codepoint == 42951:
        return chr(codepoint + (1))
    if codepoint == 42953:
        return chr(codepoint + (1))
    if codepoint == 42960:
        return chr(codepoint + (1))
    if codepoint == 42966:
        return chr(codepoint + (1))
    if codepoint == 42968:
        return chr(codepoint + (1))
    if codepoint == 42997:
        return chr(codepoint + (1))
    if codepoint >= 65313 and codepoint <= 65338:
        return chr(codepoint + (32))
    if codepoint >= 66560 and codepoint <= 66599:
        return chr(codepoint + (40))
    if codepoint >= 66736 and codepoint <= 66771:
        return chr(codepoint + (40))
    if codepoint >= 66928 and codepoint <= 66938:
        return chr(codepoint + (39))
    if codepoint >= 66940 and codepoint <= 66954:
        return chr(codepoint + (39))
    if codepoint >= 66956 and codepoint <= 66962:
        return chr(codepoint + (39))
    if codepoint >= 66964 and codepoint <= 66965:
        return chr(codepoint + (39))
    if codepoint >= 68736 and codepoint <= 68786:
        return chr(codepoint + (64))
    if codepoint >= 71840 and codepoint <= 71871:
        return chr(codepoint + (32))
    if codepoint >= 93760 and codepoint <= 93791:
        return chr(codepoint + (32))
    if codepoint >= 125184 and codepoint <= 125217:
        return chr(codepoint + (34))
    if codepoint == 304:
        return "i̇"
    return String(character)

def _titlecase_character(character: StringSlice) -> String:
    var codepoint = ord(character)
    if codepoint >= 97 and codepoint <= 122:
        return chr(codepoint + (-32))
    if codepoint == 181:
        return chr(codepoint + (743))
    if codepoint >= 224 and codepoint <= 246:
        return chr(codepoint + (-32))
    if codepoint >= 248 and codepoint <= 254:
        return chr(codepoint + (-32))
    if codepoint == 255:
        return chr(codepoint + (121))
    if codepoint == 257:
        return chr(codepoint + (-1))
    if codepoint == 259:
        return chr(codepoint + (-1))
    if codepoint == 261:
        return chr(codepoint + (-1))
    if codepoint == 263:
        return chr(codepoint + (-1))
    if codepoint == 265:
        return chr(codepoint + (-1))
    if codepoint == 267:
        return chr(codepoint + (-1))
    if codepoint == 269:
        return chr(codepoint + (-1))
    if codepoint == 271:
        return chr(codepoint + (-1))
    if codepoint == 273:
        return chr(codepoint + (-1))
    if codepoint == 275:
        return chr(codepoint + (-1))
    if codepoint == 277:
        return chr(codepoint + (-1))
    if codepoint == 279:
        return chr(codepoint + (-1))
    if codepoint == 281:
        return chr(codepoint + (-1))
    if codepoint == 283:
        return chr(codepoint + (-1))
    if codepoint == 285:
        return chr(codepoint + (-1))
    if codepoint == 287:
        return chr(codepoint + (-1))
    if codepoint == 289:
        return chr(codepoint + (-1))
    if codepoint == 291:
        return chr(codepoint + (-1))
    if codepoint == 293:
        return chr(codepoint + (-1))
    if codepoint == 295:
        return chr(codepoint + (-1))
    if codepoint == 297:
        return chr(codepoint + (-1))
    if codepoint == 299:
        return chr(codepoint + (-1))
    if codepoint == 301:
        return chr(codepoint + (-1))
    if codepoint == 303:
        return chr(codepoint + (-1))
    if codepoint == 305:
        return chr(codepoint + (-232))
    if codepoint == 307:
        return chr(codepoint + (-1))
    if codepoint == 309:
        return chr(codepoint + (-1))
    if codepoint == 311:
        return chr(codepoint + (-1))
    if codepoint == 314:
        return chr(codepoint + (-1))
    if codepoint == 316:
        return chr(codepoint + (-1))
    if codepoint == 318:
        return chr(codepoint + (-1))
    if codepoint == 320:
        return chr(codepoint + (-1))
    if codepoint == 322:
        return chr(codepoint + (-1))
    if codepoint == 324:
        return chr(codepoint + (-1))
    if codepoint == 326:
        return chr(codepoint + (-1))
    if codepoint == 328:
        return chr(codepoint + (-1))
    if codepoint == 331:
        return chr(codepoint + (-1))
    if codepoint == 333:
        return chr(codepoint + (-1))
    if codepoint == 335:
        return chr(codepoint + (-1))
    if codepoint == 337:
        return chr(codepoint + (-1))
    if codepoint == 339:
        return chr(codepoint + (-1))
    if codepoint == 341:
        return chr(codepoint + (-1))
    if codepoint == 343:
        return chr(codepoint + (-1))
    if codepoint == 345:
        return chr(codepoint + (-1))
    if codepoint == 347:
        return chr(codepoint + (-1))
    if codepoint == 349:
        return chr(codepoint + (-1))
    if codepoint == 351:
        return chr(codepoint + (-1))
    if codepoint == 353:
        return chr(codepoint + (-1))
    if codepoint == 355:
        return chr(codepoint + (-1))
    if codepoint == 357:
        return chr(codepoint + (-1))
    if codepoint == 359:
        return chr(codepoint + (-1))
    if codepoint == 361:
        return chr(codepoint + (-1))
    if codepoint == 363:
        return chr(codepoint + (-1))
    if codepoint == 365:
        return chr(codepoint + (-1))
    if codepoint == 367:
        return chr(codepoint + (-1))
    if codepoint == 369:
        return chr(codepoint + (-1))
    if codepoint == 371:
        return chr(codepoint + (-1))
    if codepoint == 373:
        return chr(codepoint + (-1))
    if codepoint == 375:
        return chr(codepoint + (-1))
    if codepoint == 378:
        return chr(codepoint + (-1))
    if codepoint == 380:
        return chr(codepoint + (-1))
    if codepoint == 382:
        return chr(codepoint + (-1))
    if codepoint == 383:
        return chr(codepoint + (-300))
    if codepoint == 384:
        return chr(codepoint + (195))
    if codepoint == 387:
        return chr(codepoint + (-1))
    if codepoint == 389:
        return chr(codepoint + (-1))
    if codepoint == 392:
        return chr(codepoint + (-1))
    if codepoint == 396:
        return chr(codepoint + (-1))
    if codepoint == 402:
        return chr(codepoint + (-1))
    if codepoint == 405:
        return chr(codepoint + (97))
    if codepoint == 409:
        return chr(codepoint + (-1))
    if codepoint == 410:
        return chr(codepoint + (163))
    if codepoint == 414:
        return chr(codepoint + (130))
    if codepoint == 417:
        return chr(codepoint + (-1))
    if codepoint == 419:
        return chr(codepoint + (-1))
    if codepoint == 421:
        return chr(codepoint + (-1))
    if codepoint == 424:
        return chr(codepoint + (-1))
    if codepoint == 429:
        return chr(codepoint + (-1))
    if codepoint == 432:
        return chr(codepoint + (-1))
    if codepoint == 436:
        return chr(codepoint + (-1))
    if codepoint == 438:
        return chr(codepoint + (-1))
    if codepoint == 441:
        return chr(codepoint + (-1))
    if codepoint == 445:
        return chr(codepoint + (-1))
    if codepoint == 447:
        return chr(codepoint + (56))
    if codepoint == 452:
        return chr(codepoint + (1))
    if codepoint == 454:
        return chr(codepoint + (-1))
    if codepoint == 455:
        return chr(codepoint + (1))
    if codepoint == 457:
        return chr(codepoint + (-1))
    if codepoint == 458:
        return chr(codepoint + (1))
    if codepoint == 460:
        return chr(codepoint + (-1))
    if codepoint == 462:
        return chr(codepoint + (-1))
    if codepoint == 464:
        return chr(codepoint + (-1))
    if codepoint == 466:
        return chr(codepoint + (-1))
    if codepoint == 468:
        return chr(codepoint + (-1))
    if codepoint == 470:
        return chr(codepoint + (-1))
    if codepoint == 472:
        return chr(codepoint + (-1))
    if codepoint == 474:
        return chr(codepoint + (-1))
    if codepoint == 476:
        return chr(codepoint + (-1))
    if codepoint == 477:
        return chr(codepoint + (-79))
    if codepoint == 479:
        return chr(codepoint + (-1))
    if codepoint == 481:
        return chr(codepoint + (-1))
    if codepoint == 483:
        return chr(codepoint + (-1))
    if codepoint == 485:
        return chr(codepoint + (-1))
    if codepoint == 487:
        return chr(codepoint + (-1))
    if codepoint == 489:
        return chr(codepoint + (-1))
    if codepoint == 491:
        return chr(codepoint + (-1))
    if codepoint == 493:
        return chr(codepoint + (-1))
    if codepoint == 495:
        return chr(codepoint + (-1))
    if codepoint == 497:
        return chr(codepoint + (1))
    if codepoint == 499:
        return chr(codepoint + (-1))
    if codepoint == 501:
        return chr(codepoint + (-1))
    if codepoint == 505:
        return chr(codepoint + (-1))
    if codepoint == 507:
        return chr(codepoint + (-1))
    if codepoint == 509:
        return chr(codepoint + (-1))
    if codepoint == 511:
        return chr(codepoint + (-1))
    if codepoint == 513:
        return chr(codepoint + (-1))
    if codepoint == 515:
        return chr(codepoint + (-1))
    if codepoint == 517:
        return chr(codepoint + (-1))
    if codepoint == 519:
        return chr(codepoint + (-1))
    if codepoint == 521:
        return chr(codepoint + (-1))
    if codepoint == 523:
        return chr(codepoint + (-1))
    if codepoint == 525:
        return chr(codepoint + (-1))
    if codepoint == 527:
        return chr(codepoint + (-1))
    if codepoint == 529:
        return chr(codepoint + (-1))
    if codepoint == 531:
        return chr(codepoint + (-1))
    if codepoint == 533:
        return chr(codepoint + (-1))
    if codepoint == 535:
        return chr(codepoint + (-1))
    if codepoint == 537:
        return chr(codepoint + (-1))
    if codepoint == 539:
        return chr(codepoint + (-1))
    if codepoint == 541:
        return chr(codepoint + (-1))
    if codepoint == 543:
        return chr(codepoint + (-1))
    if codepoint == 547:
        return chr(codepoint + (-1))
    if codepoint == 549:
        return chr(codepoint + (-1))
    if codepoint == 551:
        return chr(codepoint + (-1))
    if codepoint == 553:
        return chr(codepoint + (-1))
    if codepoint == 555:
        return chr(codepoint + (-1))
    if codepoint == 557:
        return chr(codepoint + (-1))
    if codepoint == 559:
        return chr(codepoint + (-1))
    if codepoint == 561:
        return chr(codepoint + (-1))
    if codepoint == 563:
        return chr(codepoint + (-1))
    if codepoint == 572:
        return chr(codepoint + (-1))
    if codepoint >= 575 and codepoint <= 576:
        return chr(codepoint + (10815))
    if codepoint == 578:
        return chr(codepoint + (-1))
    if codepoint == 583:
        return chr(codepoint + (-1))
    if codepoint == 585:
        return chr(codepoint + (-1))
    if codepoint == 587:
        return chr(codepoint + (-1))
    if codepoint == 589:
        return chr(codepoint + (-1))
    if codepoint == 591:
        return chr(codepoint + (-1))
    if codepoint == 592:
        return chr(codepoint + (10783))
    if codepoint == 593:
        return chr(codepoint + (10780))
    if codepoint == 594:
        return chr(codepoint + (10782))
    if codepoint == 595:
        return chr(codepoint + (-210))
    if codepoint == 596:
        return chr(codepoint + (-206))
    if codepoint >= 598 and codepoint <= 599:
        return chr(codepoint + (-205))
    if codepoint == 601:
        return chr(codepoint + (-202))
    if codepoint == 603:
        return chr(codepoint + (-203))
    if codepoint == 604:
        return chr(codepoint + (42319))
    if codepoint == 608:
        return chr(codepoint + (-205))
    if codepoint == 609:
        return chr(codepoint + (42315))
    if codepoint == 611:
        return chr(codepoint + (-207))
    if codepoint == 613:
        return chr(codepoint + (42280))
    if codepoint == 614:
        return chr(codepoint + (42308))
    if codepoint == 616:
        return chr(codepoint + (-209))
    if codepoint == 617:
        return chr(codepoint + (-211))
    if codepoint == 618:
        return chr(codepoint + (42308))
    if codepoint == 619:
        return chr(codepoint + (10743))
    if codepoint == 620:
        return chr(codepoint + (42305))
    if codepoint == 623:
        return chr(codepoint + (-211))
    if codepoint == 625:
        return chr(codepoint + (10749))
    if codepoint == 626:
        return chr(codepoint + (-213))
    if codepoint == 629:
        return chr(codepoint + (-214))
    if codepoint == 637:
        return chr(codepoint + (10727))
    if codepoint == 640:
        return chr(codepoint + (-218))
    if codepoint == 642:
        return chr(codepoint + (42307))
    if codepoint == 643:
        return chr(codepoint + (-218))
    if codepoint == 647:
        return chr(codepoint + (42282))
    if codepoint == 648:
        return chr(codepoint + (-218))
    if codepoint == 649:
        return chr(codepoint + (-69))
    if codepoint >= 650 and codepoint <= 651:
        return chr(codepoint + (-217))
    if codepoint == 652:
        return chr(codepoint + (-71))
    if codepoint == 658:
        return chr(codepoint + (-219))
    if codepoint == 669:
        return chr(codepoint + (42261))
    if codepoint == 670:
        return chr(codepoint + (42258))
    if codepoint == 837:
        return chr(codepoint + (84))
    if codepoint == 881:
        return chr(codepoint + (-1))
    if codepoint == 883:
        return chr(codepoint + (-1))
    if codepoint == 887:
        return chr(codepoint + (-1))
    if codepoint >= 891 and codepoint <= 893:
        return chr(codepoint + (130))
    if codepoint == 940:
        return chr(codepoint + (-38))
    if codepoint >= 941 and codepoint <= 943:
        return chr(codepoint + (-37))
    if codepoint >= 945 and codepoint <= 961:
        return chr(codepoint + (-32))
    if codepoint == 962:
        return chr(codepoint + (-31))
    if codepoint >= 963 and codepoint <= 971:
        return chr(codepoint + (-32))
    if codepoint == 972:
        return chr(codepoint + (-64))
    if codepoint >= 973 and codepoint <= 974:
        return chr(codepoint + (-63))
    if codepoint == 976:
        return chr(codepoint + (-62))
    if codepoint == 977:
        return chr(codepoint + (-57))
    if codepoint == 981:
        return chr(codepoint + (-47))
    if codepoint == 982:
        return chr(codepoint + (-54))
    if codepoint == 983:
        return chr(codepoint + (-8))
    if codepoint == 985:
        return chr(codepoint + (-1))
    if codepoint == 987:
        return chr(codepoint + (-1))
    if codepoint == 989:
        return chr(codepoint + (-1))
    if codepoint == 991:
        return chr(codepoint + (-1))
    if codepoint == 993:
        return chr(codepoint + (-1))
    if codepoint == 995:
        return chr(codepoint + (-1))
    if codepoint == 997:
        return chr(codepoint + (-1))
    if codepoint == 999:
        return chr(codepoint + (-1))
    if codepoint == 1001:
        return chr(codepoint + (-1))
    if codepoint == 1003:
        return chr(codepoint + (-1))
    if codepoint == 1005:
        return chr(codepoint + (-1))
    if codepoint == 1007:
        return chr(codepoint + (-1))
    if codepoint == 1008:
        return chr(codepoint + (-86))
    if codepoint == 1009:
        return chr(codepoint + (-80))
    if codepoint == 1010:
        return chr(codepoint + (7))
    if codepoint == 1011:
        return chr(codepoint + (-116))
    if codepoint == 1013:
        return chr(codepoint + (-96))
    if codepoint == 1016:
        return chr(codepoint + (-1))
    if codepoint == 1019:
        return chr(codepoint + (-1))
    if codepoint >= 1072 and codepoint <= 1103:
        return chr(codepoint + (-32))
    if codepoint >= 1104 and codepoint <= 1119:
        return chr(codepoint + (-80))
    if codepoint == 1121:
        return chr(codepoint + (-1))
    if codepoint == 1123:
        return chr(codepoint + (-1))
    if codepoint == 1125:
        return chr(codepoint + (-1))
    if codepoint == 1127:
        return chr(codepoint + (-1))
    if codepoint == 1129:
        return chr(codepoint + (-1))
    if codepoint == 1131:
        return chr(codepoint + (-1))
    if codepoint == 1133:
        return chr(codepoint + (-1))
    if codepoint == 1135:
        return chr(codepoint + (-1))
    if codepoint == 1137:
        return chr(codepoint + (-1))
    if codepoint == 1139:
        return chr(codepoint + (-1))
    if codepoint == 1141:
        return chr(codepoint + (-1))
    if codepoint == 1143:
        return chr(codepoint + (-1))
    if codepoint == 1145:
        return chr(codepoint + (-1))
    if codepoint == 1147:
        return chr(codepoint + (-1))
    if codepoint == 1149:
        return chr(codepoint + (-1))
    if codepoint == 1151:
        return chr(codepoint + (-1))
    if codepoint == 1153:
        return chr(codepoint + (-1))
    if codepoint == 1163:
        return chr(codepoint + (-1))
    if codepoint == 1165:
        return chr(codepoint + (-1))
    if codepoint == 1167:
        return chr(codepoint + (-1))
    if codepoint == 1169:
        return chr(codepoint + (-1))
    if codepoint == 1171:
        return chr(codepoint + (-1))
    if codepoint == 1173:
        return chr(codepoint + (-1))
    if codepoint == 1175:
        return chr(codepoint + (-1))
    if codepoint == 1177:
        return chr(codepoint + (-1))
    if codepoint == 1179:
        return chr(codepoint + (-1))
    if codepoint == 1181:
        return chr(codepoint + (-1))
    if codepoint == 1183:
        return chr(codepoint + (-1))
    if codepoint == 1185:
        return chr(codepoint + (-1))
    if codepoint == 1187:
        return chr(codepoint + (-1))
    if codepoint == 1189:
        return chr(codepoint + (-1))
    if codepoint == 1191:
        return chr(codepoint + (-1))
    if codepoint == 1193:
        return chr(codepoint + (-1))
    if codepoint == 1195:
        return chr(codepoint + (-1))
    if codepoint == 1197:
        return chr(codepoint + (-1))
    if codepoint == 1199:
        return chr(codepoint + (-1))
    if codepoint == 1201:
        return chr(codepoint + (-1))
    if codepoint == 1203:
        return chr(codepoint + (-1))
    if codepoint == 1205:
        return chr(codepoint + (-1))
    if codepoint == 1207:
        return chr(codepoint + (-1))
    if codepoint == 1209:
        return chr(codepoint + (-1))
    if codepoint == 1211:
        return chr(codepoint + (-1))
    if codepoint == 1213:
        return chr(codepoint + (-1))
    if codepoint == 1215:
        return chr(codepoint + (-1))
    if codepoint == 1218:
        return chr(codepoint + (-1))
    if codepoint == 1220:
        return chr(codepoint + (-1))
    if codepoint == 1222:
        return chr(codepoint + (-1))
    if codepoint == 1224:
        return chr(codepoint + (-1))
    if codepoint == 1226:
        return chr(codepoint + (-1))
    if codepoint == 1228:
        return chr(codepoint + (-1))
    if codepoint == 1230:
        return chr(codepoint + (-1))
    if codepoint == 1231:
        return chr(codepoint + (-15))
    if codepoint == 1233:
        return chr(codepoint + (-1))
    if codepoint == 1235:
        return chr(codepoint + (-1))
    if codepoint == 1237:
        return chr(codepoint + (-1))
    if codepoint == 1239:
        return chr(codepoint + (-1))
    if codepoint == 1241:
        return chr(codepoint + (-1))
    if codepoint == 1243:
        return chr(codepoint + (-1))
    if codepoint == 1245:
        return chr(codepoint + (-1))
    if codepoint == 1247:
        return chr(codepoint + (-1))
    if codepoint == 1249:
        return chr(codepoint + (-1))
    if codepoint == 1251:
        return chr(codepoint + (-1))
    if codepoint == 1253:
        return chr(codepoint + (-1))
    if codepoint == 1255:
        return chr(codepoint + (-1))
    if codepoint == 1257:
        return chr(codepoint + (-1))
    if codepoint == 1259:
        return chr(codepoint + (-1))
    if codepoint == 1261:
        return chr(codepoint + (-1))
    if codepoint == 1263:
        return chr(codepoint + (-1))
    if codepoint == 1265:
        return chr(codepoint + (-1))
    if codepoint == 1267:
        return chr(codepoint + (-1))
    if codepoint == 1269:
        return chr(codepoint + (-1))
    if codepoint == 1271:
        return chr(codepoint + (-1))
    if codepoint == 1273:
        return chr(codepoint + (-1))
    if codepoint == 1275:
        return chr(codepoint + (-1))
    if codepoint == 1277:
        return chr(codepoint + (-1))
    if codepoint == 1279:
        return chr(codepoint + (-1))
    if codepoint == 1281:
        return chr(codepoint + (-1))
    if codepoint == 1283:
        return chr(codepoint + (-1))
    if codepoint == 1285:
        return chr(codepoint + (-1))
    if codepoint == 1287:
        return chr(codepoint + (-1))
    if codepoint == 1289:
        return chr(codepoint + (-1))
    if codepoint == 1291:
        return chr(codepoint + (-1))
    if codepoint == 1293:
        return chr(codepoint + (-1))
    if codepoint == 1295:
        return chr(codepoint + (-1))
    if codepoint == 1297:
        return chr(codepoint + (-1))
    if codepoint == 1299:
        return chr(codepoint + (-1))
    if codepoint == 1301:
        return chr(codepoint + (-1))
    if codepoint == 1303:
        return chr(codepoint + (-1))
    if codepoint == 1305:
        return chr(codepoint + (-1))
    if codepoint == 1307:
        return chr(codepoint + (-1))
    if codepoint == 1309:
        return chr(codepoint + (-1))
    if codepoint == 1311:
        return chr(codepoint + (-1))
    if codepoint == 1313:
        return chr(codepoint + (-1))
    if codepoint == 1315:
        return chr(codepoint + (-1))
    if codepoint == 1317:
        return chr(codepoint + (-1))
    if codepoint == 1319:
        return chr(codepoint + (-1))
    if codepoint == 1321:
        return chr(codepoint + (-1))
    if codepoint == 1323:
        return chr(codepoint + (-1))
    if codepoint == 1325:
        return chr(codepoint + (-1))
    if codepoint == 1327:
        return chr(codepoint + (-1))
    if codepoint >= 1377 and codepoint <= 1414:
        return chr(codepoint + (-48))
    if codepoint >= 5112 and codepoint <= 5117:
        return chr(codepoint + (-8))
    if codepoint == 7296:
        return chr(codepoint + (-6254))
    if codepoint == 7297:
        return chr(codepoint + (-6253))
    if codepoint == 7298:
        return chr(codepoint + (-6244))
    if codepoint >= 7299 and codepoint <= 7300:
        return chr(codepoint + (-6242))
    if codepoint == 7301:
        return chr(codepoint + (-6243))
    if codepoint == 7302:
        return chr(codepoint + (-6236))
    if codepoint == 7303:
        return chr(codepoint + (-6181))
    if codepoint == 7304:
        return chr(codepoint + (35266))
    if codepoint == 7545:
        return chr(codepoint + (35332))
    if codepoint == 7549:
        return chr(codepoint + (3814))
    if codepoint == 7566:
        return chr(codepoint + (35384))
    if codepoint == 7681:
        return chr(codepoint + (-1))
    if codepoint == 7683:
        return chr(codepoint + (-1))
    if codepoint == 7685:
        return chr(codepoint + (-1))
    if codepoint == 7687:
        return chr(codepoint + (-1))
    if codepoint == 7689:
        return chr(codepoint + (-1))
    if codepoint == 7691:
        return chr(codepoint + (-1))
    if codepoint == 7693:
        return chr(codepoint + (-1))
    if codepoint == 7695:
        return chr(codepoint + (-1))
    if codepoint == 7697:
        return chr(codepoint + (-1))
    if codepoint == 7699:
        return chr(codepoint + (-1))
    if codepoint == 7701:
        return chr(codepoint + (-1))
    if codepoint == 7703:
        return chr(codepoint + (-1))
    if codepoint == 7705:
        return chr(codepoint + (-1))
    if codepoint == 7707:
        return chr(codepoint + (-1))
    if codepoint == 7709:
        return chr(codepoint + (-1))
    if codepoint == 7711:
        return chr(codepoint + (-1))
    if codepoint == 7713:
        return chr(codepoint + (-1))
    if codepoint == 7715:
        return chr(codepoint + (-1))
    if codepoint == 7717:
        return chr(codepoint + (-1))
    if codepoint == 7719:
        return chr(codepoint + (-1))
    if codepoint == 7721:
        return chr(codepoint + (-1))
    if codepoint == 7723:
        return chr(codepoint + (-1))
    if codepoint == 7725:
        return chr(codepoint + (-1))
    if codepoint == 7727:
        return chr(codepoint + (-1))
    if codepoint == 7729:
        return chr(codepoint + (-1))
    if codepoint == 7731:
        return chr(codepoint + (-1))
    if codepoint == 7733:
        return chr(codepoint + (-1))
    if codepoint == 7735:
        return chr(codepoint + (-1))
    if codepoint == 7737:
        return chr(codepoint + (-1))
    if codepoint == 7739:
        return chr(codepoint + (-1))
    if codepoint == 7741:
        return chr(codepoint + (-1))
    if codepoint == 7743:
        return chr(codepoint + (-1))
    if codepoint == 7745:
        return chr(codepoint + (-1))
    if codepoint == 7747:
        return chr(codepoint + (-1))
    if codepoint == 7749:
        return chr(codepoint + (-1))
    if codepoint == 7751:
        return chr(codepoint + (-1))
    if codepoint == 7753:
        return chr(codepoint + (-1))
    if codepoint == 7755:
        return chr(codepoint + (-1))
    if codepoint == 7757:
        return chr(codepoint + (-1))
    if codepoint == 7759:
        return chr(codepoint + (-1))
    if codepoint == 7761:
        return chr(codepoint + (-1))
    if codepoint == 7763:
        return chr(codepoint + (-1))
    if codepoint == 7765:
        return chr(codepoint + (-1))
    if codepoint == 7767:
        return chr(codepoint + (-1))
    if codepoint == 7769:
        return chr(codepoint + (-1))
    if codepoint == 7771:
        return chr(codepoint + (-1))
    if codepoint == 7773:
        return chr(codepoint + (-1))
    if codepoint == 7775:
        return chr(codepoint + (-1))
    if codepoint == 7777:
        return chr(codepoint + (-1))
    if codepoint == 7779:
        return chr(codepoint + (-1))
    if codepoint == 7781:
        return chr(codepoint + (-1))
    if codepoint == 7783:
        return chr(codepoint + (-1))
    if codepoint == 7785:
        return chr(codepoint + (-1))
    if codepoint == 7787:
        return chr(codepoint + (-1))
    if codepoint == 7789:
        return chr(codepoint + (-1))
    if codepoint == 7791:
        return chr(codepoint + (-1))
    if codepoint == 7793:
        return chr(codepoint + (-1))
    if codepoint == 7795:
        return chr(codepoint + (-1))
    if codepoint == 7797:
        return chr(codepoint + (-1))
    if codepoint == 7799:
        return chr(codepoint + (-1))
    if codepoint == 7801:
        return chr(codepoint + (-1))
    if codepoint == 7803:
        return chr(codepoint + (-1))
    if codepoint == 7805:
        return chr(codepoint + (-1))
    if codepoint == 7807:
        return chr(codepoint + (-1))
    if codepoint == 7809:
        return chr(codepoint + (-1))
    if codepoint == 7811:
        return chr(codepoint + (-1))
    if codepoint == 7813:
        return chr(codepoint + (-1))
    if codepoint == 7815:
        return chr(codepoint + (-1))
    if codepoint == 7817:
        return chr(codepoint + (-1))
    if codepoint == 7819:
        return chr(codepoint + (-1))
    if codepoint == 7821:
        return chr(codepoint + (-1))
    if codepoint == 7823:
        return chr(codepoint + (-1))
    if codepoint == 7825:
        return chr(codepoint + (-1))
    if codepoint == 7827:
        return chr(codepoint + (-1))
    if codepoint == 7829:
        return chr(codepoint + (-1))
    if codepoint == 7835:
        return chr(codepoint + (-59))
    if codepoint == 7841:
        return chr(codepoint + (-1))
    if codepoint == 7843:
        return chr(codepoint + (-1))
    if codepoint == 7845:
        return chr(codepoint + (-1))
    if codepoint == 7847:
        return chr(codepoint + (-1))
    if codepoint == 7849:
        return chr(codepoint + (-1))
    if codepoint == 7851:
        return chr(codepoint + (-1))
    if codepoint == 7853:
        return chr(codepoint + (-1))
    if codepoint == 7855:
        return chr(codepoint + (-1))
    if codepoint == 7857:
        return chr(codepoint + (-1))
    if codepoint == 7859:
        return chr(codepoint + (-1))
    if codepoint == 7861:
        return chr(codepoint + (-1))
    if codepoint == 7863:
        return chr(codepoint + (-1))
    if codepoint == 7865:
        return chr(codepoint + (-1))
    if codepoint == 7867:
        return chr(codepoint + (-1))
    if codepoint == 7869:
        return chr(codepoint + (-1))
    if codepoint == 7871:
        return chr(codepoint + (-1))
    if codepoint == 7873:
        return chr(codepoint + (-1))
    if codepoint == 7875:
        return chr(codepoint + (-1))
    if codepoint == 7877:
        return chr(codepoint + (-1))
    if codepoint == 7879:
        return chr(codepoint + (-1))
    if codepoint == 7881:
        return chr(codepoint + (-1))
    if codepoint == 7883:
        return chr(codepoint + (-1))
    if codepoint == 7885:
        return chr(codepoint + (-1))
    if codepoint == 7887:
        return chr(codepoint + (-1))
    if codepoint == 7889:
        return chr(codepoint + (-1))
    if codepoint == 7891:
        return chr(codepoint + (-1))
    if codepoint == 7893:
        return chr(codepoint + (-1))
    if codepoint == 7895:
        return chr(codepoint + (-1))
    if codepoint == 7897:
        return chr(codepoint + (-1))
    if codepoint == 7899:
        return chr(codepoint + (-1))
    if codepoint == 7901:
        return chr(codepoint + (-1))
    if codepoint == 7903:
        return chr(codepoint + (-1))
    if codepoint == 7905:
        return chr(codepoint + (-1))
    if codepoint == 7907:
        return chr(codepoint + (-1))
    if codepoint == 7909:
        return chr(codepoint + (-1))
    if codepoint == 7911:
        return chr(codepoint + (-1))
    if codepoint == 7913:
        return chr(codepoint + (-1))
    if codepoint == 7915:
        return chr(codepoint + (-1))
    if codepoint == 7917:
        return chr(codepoint + (-1))
    if codepoint == 7919:
        return chr(codepoint + (-1))
    if codepoint == 7921:
        return chr(codepoint + (-1))
    if codepoint == 7923:
        return chr(codepoint + (-1))
    if codepoint == 7925:
        return chr(codepoint + (-1))
    if codepoint == 7927:
        return chr(codepoint + (-1))
    if codepoint == 7929:
        return chr(codepoint + (-1))
    if codepoint == 7931:
        return chr(codepoint + (-1))
    if codepoint == 7933:
        return chr(codepoint + (-1))
    if codepoint == 7935:
        return chr(codepoint + (-1))
    if codepoint >= 7936 and codepoint <= 7943:
        return chr(codepoint + (8))
    if codepoint >= 7952 and codepoint <= 7957:
        return chr(codepoint + (8))
    if codepoint >= 7968 and codepoint <= 7975:
        return chr(codepoint + (8))
    if codepoint >= 7984 and codepoint <= 7991:
        return chr(codepoint + (8))
    if codepoint >= 8000 and codepoint <= 8005:
        return chr(codepoint + (8))
    if codepoint == 8017:
        return chr(codepoint + (8))
    if codepoint == 8019:
        return chr(codepoint + (8))
    if codepoint == 8021:
        return chr(codepoint + (8))
    if codepoint == 8023:
        return chr(codepoint + (8))
    if codepoint >= 8032 and codepoint <= 8039:
        return chr(codepoint + (8))
    if codepoint >= 8048 and codepoint <= 8049:
        return chr(codepoint + (74))
    if codepoint >= 8050 and codepoint <= 8053:
        return chr(codepoint + (86))
    if codepoint >= 8054 and codepoint <= 8055:
        return chr(codepoint + (100))
    if codepoint >= 8056 and codepoint <= 8057:
        return chr(codepoint + (128))
    if codepoint >= 8058 and codepoint <= 8059:
        return chr(codepoint + (112))
    if codepoint >= 8060 and codepoint <= 8061:
        return chr(codepoint + (126))
    if codepoint >= 8064 and codepoint <= 8071:
        return chr(codepoint + (8))
    if codepoint >= 8080 and codepoint <= 8087:
        return chr(codepoint + (8))
    if codepoint >= 8096 and codepoint <= 8103:
        return chr(codepoint + (8))
    if codepoint >= 8112 and codepoint <= 8113:
        return chr(codepoint + (8))
    if codepoint == 8115:
        return chr(codepoint + (9))
    if codepoint == 8126:
        return chr(codepoint + (-7205))
    if codepoint == 8131:
        return chr(codepoint + (9))
    if codepoint >= 8144 and codepoint <= 8145:
        return chr(codepoint + (8))
    if codepoint >= 8160 and codepoint <= 8161:
        return chr(codepoint + (8))
    if codepoint == 8165:
        return chr(codepoint + (7))
    if codepoint == 8179:
        return chr(codepoint + (9))
    if codepoint == 8526:
        return chr(codepoint + (-28))
    if codepoint >= 8560 and codepoint <= 8575:
        return chr(codepoint + (-16))
    if codepoint == 8580:
        return chr(codepoint + (-1))
    if codepoint >= 9424 and codepoint <= 9449:
        return chr(codepoint + (-26))
    if codepoint >= 11312 and codepoint <= 11359:
        return chr(codepoint + (-48))
    if codepoint == 11361:
        return chr(codepoint + (-1))
    if codepoint == 11365:
        return chr(codepoint + (-10795))
    if codepoint == 11366:
        return chr(codepoint + (-10792))
    if codepoint == 11368:
        return chr(codepoint + (-1))
    if codepoint == 11370:
        return chr(codepoint + (-1))
    if codepoint == 11372:
        return chr(codepoint + (-1))
    if codepoint == 11379:
        return chr(codepoint + (-1))
    if codepoint == 11382:
        return chr(codepoint + (-1))
    if codepoint == 11393:
        return chr(codepoint + (-1))
    if codepoint == 11395:
        return chr(codepoint + (-1))
    if codepoint == 11397:
        return chr(codepoint + (-1))
    if codepoint == 11399:
        return chr(codepoint + (-1))
    if codepoint == 11401:
        return chr(codepoint + (-1))
    if codepoint == 11403:
        return chr(codepoint + (-1))
    if codepoint == 11405:
        return chr(codepoint + (-1))
    if codepoint == 11407:
        return chr(codepoint + (-1))
    if codepoint == 11409:
        return chr(codepoint + (-1))
    if codepoint == 11411:
        return chr(codepoint + (-1))
    if codepoint == 11413:
        return chr(codepoint + (-1))
    if codepoint == 11415:
        return chr(codepoint + (-1))
    if codepoint == 11417:
        return chr(codepoint + (-1))
    if codepoint == 11419:
        return chr(codepoint + (-1))
    if codepoint == 11421:
        return chr(codepoint + (-1))
    if codepoint == 11423:
        return chr(codepoint + (-1))
    if codepoint == 11425:
        return chr(codepoint + (-1))
    if codepoint == 11427:
        return chr(codepoint + (-1))
    if codepoint == 11429:
        return chr(codepoint + (-1))
    if codepoint == 11431:
        return chr(codepoint + (-1))
    if codepoint == 11433:
        return chr(codepoint + (-1))
    if codepoint == 11435:
        return chr(codepoint + (-1))
    if codepoint == 11437:
        return chr(codepoint + (-1))
    if codepoint == 11439:
        return chr(codepoint + (-1))
    if codepoint == 11441:
        return chr(codepoint + (-1))
    if codepoint == 11443:
        return chr(codepoint + (-1))
    if codepoint == 11445:
        return chr(codepoint + (-1))
    if codepoint == 11447:
        return chr(codepoint + (-1))
    if codepoint == 11449:
        return chr(codepoint + (-1))
    if codepoint == 11451:
        return chr(codepoint + (-1))
    if codepoint == 11453:
        return chr(codepoint + (-1))
    if codepoint == 11455:
        return chr(codepoint + (-1))
    if codepoint == 11457:
        return chr(codepoint + (-1))
    if codepoint == 11459:
        return chr(codepoint + (-1))
    if codepoint == 11461:
        return chr(codepoint + (-1))
    if codepoint == 11463:
        return chr(codepoint + (-1))
    if codepoint == 11465:
        return chr(codepoint + (-1))
    if codepoint == 11467:
        return chr(codepoint + (-1))
    if codepoint == 11469:
        return chr(codepoint + (-1))
    if codepoint == 11471:
        return chr(codepoint + (-1))
    if codepoint == 11473:
        return chr(codepoint + (-1))
    if codepoint == 11475:
        return chr(codepoint + (-1))
    if codepoint == 11477:
        return chr(codepoint + (-1))
    if codepoint == 11479:
        return chr(codepoint + (-1))
    if codepoint == 11481:
        return chr(codepoint + (-1))
    if codepoint == 11483:
        return chr(codepoint + (-1))
    if codepoint == 11485:
        return chr(codepoint + (-1))
    if codepoint == 11487:
        return chr(codepoint + (-1))
    if codepoint == 11489:
        return chr(codepoint + (-1))
    if codepoint == 11491:
        return chr(codepoint + (-1))
    if codepoint == 11500:
        return chr(codepoint + (-1))
    if codepoint == 11502:
        return chr(codepoint + (-1))
    if codepoint == 11507:
        return chr(codepoint + (-1))
    if codepoint >= 11520 and codepoint <= 11557:
        return chr(codepoint + (-7264))
    if codepoint == 11559:
        return chr(codepoint + (-7264))
    if codepoint == 11565:
        return chr(codepoint + (-7264))
    if codepoint == 42561:
        return chr(codepoint + (-1))
    if codepoint == 42563:
        return chr(codepoint + (-1))
    if codepoint == 42565:
        return chr(codepoint + (-1))
    if codepoint == 42567:
        return chr(codepoint + (-1))
    if codepoint == 42569:
        return chr(codepoint + (-1))
    if codepoint == 42571:
        return chr(codepoint + (-1))
    if codepoint == 42573:
        return chr(codepoint + (-1))
    if codepoint == 42575:
        return chr(codepoint + (-1))
    if codepoint == 42577:
        return chr(codepoint + (-1))
    if codepoint == 42579:
        return chr(codepoint + (-1))
    if codepoint == 42581:
        return chr(codepoint + (-1))
    if codepoint == 42583:
        return chr(codepoint + (-1))
    if codepoint == 42585:
        return chr(codepoint + (-1))
    if codepoint == 42587:
        return chr(codepoint + (-1))
    if codepoint == 42589:
        return chr(codepoint + (-1))
    if codepoint == 42591:
        return chr(codepoint + (-1))
    if codepoint == 42593:
        return chr(codepoint + (-1))
    if codepoint == 42595:
        return chr(codepoint + (-1))
    if codepoint == 42597:
        return chr(codepoint + (-1))
    if codepoint == 42599:
        return chr(codepoint + (-1))
    if codepoint == 42601:
        return chr(codepoint + (-1))
    if codepoint == 42603:
        return chr(codepoint + (-1))
    if codepoint == 42605:
        return chr(codepoint + (-1))
    if codepoint == 42625:
        return chr(codepoint + (-1))
    if codepoint == 42627:
        return chr(codepoint + (-1))
    if codepoint == 42629:
        return chr(codepoint + (-1))
    if codepoint == 42631:
        return chr(codepoint + (-1))
    if codepoint == 42633:
        return chr(codepoint + (-1))
    if codepoint == 42635:
        return chr(codepoint + (-1))
    if codepoint == 42637:
        return chr(codepoint + (-1))
    if codepoint == 42639:
        return chr(codepoint + (-1))
    if codepoint == 42641:
        return chr(codepoint + (-1))
    if codepoint == 42643:
        return chr(codepoint + (-1))
    if codepoint == 42645:
        return chr(codepoint + (-1))
    if codepoint == 42647:
        return chr(codepoint + (-1))
    if codepoint == 42649:
        return chr(codepoint + (-1))
    if codepoint == 42651:
        return chr(codepoint + (-1))
    if codepoint == 42787:
        return chr(codepoint + (-1))
    if codepoint == 42789:
        return chr(codepoint + (-1))
    if codepoint == 42791:
        return chr(codepoint + (-1))
    if codepoint == 42793:
        return chr(codepoint + (-1))
    if codepoint == 42795:
        return chr(codepoint + (-1))
    if codepoint == 42797:
        return chr(codepoint + (-1))
    if codepoint == 42799:
        return chr(codepoint + (-1))
    if codepoint == 42803:
        return chr(codepoint + (-1))
    if codepoint == 42805:
        return chr(codepoint + (-1))
    if codepoint == 42807:
        return chr(codepoint + (-1))
    if codepoint == 42809:
        return chr(codepoint + (-1))
    if codepoint == 42811:
        return chr(codepoint + (-1))
    if codepoint == 42813:
        return chr(codepoint + (-1))
    if codepoint == 42815:
        return chr(codepoint + (-1))
    if codepoint == 42817:
        return chr(codepoint + (-1))
    if codepoint == 42819:
        return chr(codepoint + (-1))
    if codepoint == 42821:
        return chr(codepoint + (-1))
    if codepoint == 42823:
        return chr(codepoint + (-1))
    if codepoint == 42825:
        return chr(codepoint + (-1))
    if codepoint == 42827:
        return chr(codepoint + (-1))
    if codepoint == 42829:
        return chr(codepoint + (-1))
    if codepoint == 42831:
        return chr(codepoint + (-1))
    if codepoint == 42833:
        return chr(codepoint + (-1))
    if codepoint == 42835:
        return chr(codepoint + (-1))
    if codepoint == 42837:
        return chr(codepoint + (-1))
    if codepoint == 42839:
        return chr(codepoint + (-1))
    if codepoint == 42841:
        return chr(codepoint + (-1))
    if codepoint == 42843:
        return chr(codepoint + (-1))
    if codepoint == 42845:
        return chr(codepoint + (-1))
    if codepoint == 42847:
        return chr(codepoint + (-1))
    if codepoint == 42849:
        return chr(codepoint + (-1))
    if codepoint == 42851:
        return chr(codepoint + (-1))
    if codepoint == 42853:
        return chr(codepoint + (-1))
    if codepoint == 42855:
        return chr(codepoint + (-1))
    if codepoint == 42857:
        return chr(codepoint + (-1))
    if codepoint == 42859:
        return chr(codepoint + (-1))
    if codepoint == 42861:
        return chr(codepoint + (-1))
    if codepoint == 42863:
        return chr(codepoint + (-1))
    if codepoint == 42874:
        return chr(codepoint + (-1))
    if codepoint == 42876:
        return chr(codepoint + (-1))
    if codepoint == 42879:
        return chr(codepoint + (-1))
    if codepoint == 42881:
        return chr(codepoint + (-1))
    if codepoint == 42883:
        return chr(codepoint + (-1))
    if codepoint == 42885:
        return chr(codepoint + (-1))
    if codepoint == 42887:
        return chr(codepoint + (-1))
    if codepoint == 42892:
        return chr(codepoint + (-1))
    if codepoint == 42897:
        return chr(codepoint + (-1))
    if codepoint == 42899:
        return chr(codepoint + (-1))
    if codepoint == 42900:
        return chr(codepoint + (48))
    if codepoint == 42903:
        return chr(codepoint + (-1))
    if codepoint == 42905:
        return chr(codepoint + (-1))
    if codepoint == 42907:
        return chr(codepoint + (-1))
    if codepoint == 42909:
        return chr(codepoint + (-1))
    if codepoint == 42911:
        return chr(codepoint + (-1))
    if codepoint == 42913:
        return chr(codepoint + (-1))
    if codepoint == 42915:
        return chr(codepoint + (-1))
    if codepoint == 42917:
        return chr(codepoint + (-1))
    if codepoint == 42919:
        return chr(codepoint + (-1))
    if codepoint == 42921:
        return chr(codepoint + (-1))
    if codepoint == 42933:
        return chr(codepoint + (-1))
    if codepoint == 42935:
        return chr(codepoint + (-1))
    if codepoint == 42937:
        return chr(codepoint + (-1))
    if codepoint == 42939:
        return chr(codepoint + (-1))
    if codepoint == 42941:
        return chr(codepoint + (-1))
    if codepoint == 42943:
        return chr(codepoint + (-1))
    if codepoint == 42945:
        return chr(codepoint + (-1))
    if codepoint == 42947:
        return chr(codepoint + (-1))
    if codepoint == 42952:
        return chr(codepoint + (-1))
    if codepoint == 42954:
        return chr(codepoint + (-1))
    if codepoint == 42961:
        return chr(codepoint + (-1))
    if codepoint == 42967:
        return chr(codepoint + (-1))
    if codepoint == 42969:
        return chr(codepoint + (-1))
    if codepoint == 42998:
        return chr(codepoint + (-1))
    if codepoint == 43859:
        return chr(codepoint + (-928))
    if codepoint >= 43888 and codepoint <= 43967:
        return chr(codepoint + (-38864))
    if codepoint >= 65345 and codepoint <= 65370:
        return chr(codepoint + (-32))
    if codepoint >= 66600 and codepoint <= 66639:
        return chr(codepoint + (-40))
    if codepoint >= 66776 and codepoint <= 66811:
        return chr(codepoint + (-40))
    if codepoint >= 66967 and codepoint <= 66977:
        return chr(codepoint + (-39))
    if codepoint >= 66979 and codepoint <= 66993:
        return chr(codepoint + (-39))
    if codepoint >= 66995 and codepoint <= 67001:
        return chr(codepoint + (-39))
    if codepoint >= 67003 and codepoint <= 67004:
        return chr(codepoint + (-39))
    if codepoint >= 68800 and codepoint <= 68850:
        return chr(codepoint + (-64))
    if codepoint >= 71872 and codepoint <= 71903:
        return chr(codepoint + (-32))
    if codepoint >= 93792 and codepoint <= 93823:
        return chr(codepoint + (-32))
    if codepoint >= 125218 and codepoint <= 125251:
        return chr(codepoint + (-34))
    if codepoint == 223:
        return "Ss"
    if codepoint == 329:
        return "ʼN"
    if codepoint == 496:
        return "J̌"
    if codepoint == 912:
        return "Ϊ́"
    if codepoint == 944:
        return "Ϋ́"
    if codepoint == 1415:
        return "Եւ"
    if codepoint == 7830:
        return "H̱"
    if codepoint == 7831:
        return "T̈"
    if codepoint == 7832:
        return "W̊"
    if codepoint == 7833:
        return "Y̊"
    if codepoint == 7834:
        return "Aʾ"
    if codepoint == 8016:
        return "Υ̓"
    if codepoint == 8018:
        return "Υ̓̀"
    if codepoint == 8020:
        return "Υ̓́"
    if codepoint == 8022:
        return "Υ̓͂"
    if codepoint == 8114:
        return "Ὰͅ"
    if codepoint == 8116:
        return "Άͅ"
    if codepoint == 8118:
        return "Α͂"
    if codepoint == 8119:
        return "ᾼ͂"
    if codepoint == 8130:
        return "Ὴͅ"
    if codepoint == 8132:
        return "Ήͅ"
    if codepoint == 8134:
        return "Η͂"
    if codepoint == 8135:
        return "ῌ͂"
    if codepoint == 8146:
        return "Ϊ̀"
    if codepoint == 8147:
        return "Ϊ́"
    if codepoint == 8150:
        return "Ι͂"
    if codepoint == 8151:
        return "Ϊ͂"
    if codepoint == 8162:
        return "Ϋ̀"
    if codepoint == 8163:
        return "Ϋ́"
    if codepoint == 8164:
        return "Ρ̓"
    if codepoint == 8166:
        return "Υ͂"
    if codepoint == 8167:
        return "Ϋ͂"
    if codepoint == 8178:
        return "Ὼͅ"
    if codepoint == 8180:
        return "Ώͅ"
    if codepoint == 8182:
        return "Ω͂"
    if codepoint == 8183:
        return "ῼ͂"
    if codepoint == 64256:
        return "Ff"
    if codepoint == 64257:
        return "Fi"
    if codepoint == 64258:
        return "Fl"
    if codepoint == 64259:
        return "Ffi"
    if codepoint == 64260:
        return "Ffl"
    if codepoint == 64261:
        return "St"
    if codepoint == 64262:
        return "St"
    if codepoint == 64275:
        return "Մն"
    if codepoint == 64276:
        return "Մե"
    if codepoint == 64277:
        return "Մի"
    if codepoint == 64278:
        return "Վն"
    if codepoint == 64279:
        return "Մխ"
    return String(character)

def _is_cased_character(character: StringSlice) -> Bool:
    var codepoint = ord(character)
    if codepoint >= 65 and codepoint <= 90:
        return True
    if codepoint >= 97 and codepoint <= 122:
        return True
    if codepoint == 170:
        return True
    if codepoint == 181:
        return True
    if codepoint == 186:
        return True
    if codepoint >= 192 and codepoint <= 214:
        return True
    if codepoint >= 216 and codepoint <= 246:
        return True
    if codepoint >= 248 and codepoint <= 442:
        return True
    if codepoint >= 444 and codepoint <= 447:
        return True
    if codepoint >= 452 and codepoint <= 659:
        return True
    if codepoint >= 661 and codepoint <= 696:
        return True
    if codepoint >= 704 and codepoint <= 705:
        return True
    if codepoint >= 736 and codepoint <= 740:
        return True
    if codepoint == 837:
        return True
    if codepoint >= 880 and codepoint <= 883:
        return True
    if codepoint >= 886 and codepoint <= 887:
        return True
    if codepoint >= 890 and codepoint <= 893:
        return True
    if codepoint == 895:
        return True
    if codepoint == 902:
        return True
    if codepoint >= 904 and codepoint <= 906:
        return True
    if codepoint == 908:
        return True
    if codepoint >= 910 and codepoint <= 929:
        return True
    if codepoint >= 931 and codepoint <= 1013:
        return True
    if codepoint >= 1015 and codepoint <= 1153:
        return True
    if codepoint >= 1162 and codepoint <= 1327:
        return True
    if codepoint >= 1329 and codepoint <= 1366:
        return True
    if codepoint >= 1376 and codepoint <= 1416:
        return True
    if codepoint >= 4256 and codepoint <= 4293:
        return True
    if codepoint == 4295:
        return True
    if codepoint == 4301:
        return True
    if codepoint >= 4304 and codepoint <= 4346:
        return True
    if codepoint >= 4349 and codepoint <= 4351:
        return True
    if codepoint >= 5024 and codepoint <= 5109:
        return True
    if codepoint >= 5112 and codepoint <= 5117:
        return True
    if codepoint >= 7296 and codepoint <= 7304:
        return True
    if codepoint >= 7312 and codepoint <= 7354:
        return True
    if codepoint >= 7357 and codepoint <= 7359:
        return True
    if codepoint >= 7424 and codepoint <= 7615:
        return True
    if codepoint >= 7680 and codepoint <= 7957:
        return True
    if codepoint >= 7960 and codepoint <= 7965:
        return True
    if codepoint >= 7968 and codepoint <= 8005:
        return True
    if codepoint >= 8008 and codepoint <= 8013:
        return True
    if codepoint >= 8016 and codepoint <= 8023:
        return True
    if codepoint == 8025:
        return True
    if codepoint == 8027:
        return True
    if codepoint == 8029:
        return True
    if codepoint >= 8031 and codepoint <= 8061:
        return True
    if codepoint >= 8064 and codepoint <= 8116:
        return True
    if codepoint >= 8118 and codepoint <= 8124:
        return True
    if codepoint == 8126:
        return True
    if codepoint >= 8130 and codepoint <= 8132:
        return True
    if codepoint >= 8134 and codepoint <= 8140:
        return True
    if codepoint >= 8144 and codepoint <= 8147:
        return True
    if codepoint >= 8150 and codepoint <= 8155:
        return True
    if codepoint >= 8160 and codepoint <= 8172:
        return True
    if codepoint >= 8178 and codepoint <= 8180:
        return True
    if codepoint >= 8182 and codepoint <= 8188:
        return True
    if codepoint == 8305:
        return True
    if codepoint == 8319:
        return True
    if codepoint >= 8336 and codepoint <= 8348:
        return True
    if codepoint == 8450:
        return True
    if codepoint == 8455:
        return True
    if codepoint >= 8458 and codepoint <= 8467:
        return True
    if codepoint == 8469:
        return True
    if codepoint >= 8473 and codepoint <= 8477:
        return True
    if codepoint == 8484:
        return True
    if codepoint == 8486:
        return True
    if codepoint == 8488:
        return True
    if codepoint >= 8490 and codepoint <= 8493:
        return True
    if codepoint >= 8495 and codepoint <= 8500:
        return True
    if codepoint == 8505:
        return True
    if codepoint >= 8508 and codepoint <= 8511:
        return True
    if codepoint >= 8517 and codepoint <= 8521:
        return True
    if codepoint == 8526:
        return True
    if codepoint >= 8544 and codepoint <= 8575:
        return True
    if codepoint >= 8579 and codepoint <= 8580:
        return True
    if codepoint >= 9398 and codepoint <= 9449:
        return True
    if codepoint >= 11264 and codepoint <= 11492:
        return True
    if codepoint >= 11499 and codepoint <= 11502:
        return True
    if codepoint >= 11506 and codepoint <= 11507:
        return True
    if codepoint >= 11520 and codepoint <= 11557:
        return True
    if codepoint == 11559:
        return True
    if codepoint == 11565:
        return True
    if codepoint >= 42560 and codepoint <= 42605:
        return True
    if codepoint >= 42624 and codepoint <= 42653:
        return True
    if codepoint >= 42786 and codepoint <= 42887:
        return True
    if codepoint >= 42891 and codepoint <= 42894:
        return True
    if codepoint >= 42896 and codepoint <= 42954:
        return True
    if codepoint >= 42960 and codepoint <= 42961:
        return True
    if codepoint == 42963:
        return True
    if codepoint >= 42965 and codepoint <= 42969:
        return True
    if codepoint >= 42997 and codepoint <= 42998:
        return True
    if codepoint >= 43000 and codepoint <= 43002:
        return True
    if codepoint >= 43824 and codepoint <= 43866:
        return True
    if codepoint >= 43868 and codepoint <= 43880:
        return True
    if codepoint >= 43888 and codepoint <= 43967:
        return True
    if codepoint >= 64256 and codepoint <= 64262:
        return True
    if codepoint >= 64275 and codepoint <= 64279:
        return True
    if codepoint >= 65313 and codepoint <= 65338:
        return True
    if codepoint >= 65345 and codepoint <= 65370:
        return True
    if codepoint >= 66560 and codepoint <= 66639:
        return True
    if codepoint >= 66736 and codepoint <= 66771:
        return True
    if codepoint >= 66776 and codepoint <= 66811:
        return True
    if codepoint >= 66928 and codepoint <= 66938:
        return True
    if codepoint >= 66940 and codepoint <= 66954:
        return True
    if codepoint >= 66956 and codepoint <= 66962:
        return True
    if codepoint >= 66964 and codepoint <= 66965:
        return True
    if codepoint >= 66967 and codepoint <= 66977:
        return True
    if codepoint >= 66979 and codepoint <= 66993:
        return True
    if codepoint >= 66995 and codepoint <= 67001:
        return True
    if codepoint >= 67003 and codepoint <= 67004:
        return True
    if codepoint == 67456:
        return True
    if codepoint >= 67459 and codepoint <= 67461:
        return True
    if codepoint >= 67463 and codepoint <= 67504:
        return True
    if codepoint >= 67506 and codepoint <= 67514:
        return True
    if codepoint >= 68736 and codepoint <= 68786:
        return True
    if codepoint >= 68800 and codepoint <= 68850:
        return True
    if codepoint >= 71840 and codepoint <= 71903:
        return True
    if codepoint >= 93760 and codepoint <= 93823:
        return True
    if codepoint >= 119808 and codepoint <= 119892:
        return True
    if codepoint >= 119894 and codepoint <= 119964:
        return True
    if codepoint >= 119966 and codepoint <= 119967:
        return True
    if codepoint == 119970:
        return True
    if codepoint >= 119973 and codepoint <= 119974:
        return True
    if codepoint >= 119977 and codepoint <= 119980:
        return True
    if codepoint >= 119982 and codepoint <= 119993:
        return True
    if codepoint == 119995:
        return True
    if codepoint >= 119997 and codepoint <= 120003:
        return True
    if codepoint >= 120005 and codepoint <= 120069:
        return True
    if codepoint >= 120071 and codepoint <= 120074:
        return True
    if codepoint >= 120077 and codepoint <= 120084:
        return True
    if codepoint >= 120086 and codepoint <= 120092:
        return True
    if codepoint >= 120094 and codepoint <= 120121:
        return True
    if codepoint >= 120123 and codepoint <= 120126:
        return True
    if codepoint >= 120128 and codepoint <= 120132:
        return True
    if codepoint == 120134:
        return True
    if codepoint >= 120138 and codepoint <= 120144:
        return True
    if codepoint >= 120146 and codepoint <= 120485:
        return True
    if codepoint >= 120488 and codepoint <= 120512:
        return True
    if codepoint >= 120514 and codepoint <= 120538:
        return True
    if codepoint >= 120540 and codepoint <= 120570:
        return True
    if codepoint >= 120572 and codepoint <= 120596:
        return True
    if codepoint >= 120598 and codepoint <= 120628:
        return True
    if codepoint >= 120630 and codepoint <= 120654:
        return True
    if codepoint >= 120656 and codepoint <= 120686:
        return True
    if codepoint >= 120688 and codepoint <= 120712:
        return True
    if codepoint >= 120714 and codepoint <= 120744:
        return True
    if codepoint >= 120746 and codepoint <= 120770:
        return True
    if codepoint >= 120772 and codepoint <= 120779:
        return True
    if codepoint >= 122624 and codepoint <= 122633:
        return True
    if codepoint >= 122635 and codepoint <= 122654:
        return True
    if codepoint >= 125184 and codepoint <= 125251:
        return True
    if codepoint >= 127280 and codepoint <= 127305:
        return True
    if codepoint >= 127312 and codepoint <= 127337:
        return True
    if codepoint >= 127344 and codepoint <= 127369:
        return True
    return False
