--- 创建测试数据
function initTestData()
  print('DT: 初始化地下堡测试数据')
  DRT_DB = {}
  local tb1 = {}
  tb1[1] = { zone = '九号挖掘场', tier = 11 }
  tb1[2] = { zone = '塔克-雷桑深渊', tier = 8 }
  tb1[3] = { zone = '克莱格瓦之眠', tier = 8 }
  tb1[4] = { zone = '闸板陋巷', tier = 2 }
  tb1[5] = { zone = '幽暗要塞', tier = 11 }
  tb1[6] = { zone = '地铺矿洞', tier = 5 }
  tb1[7] = { zone = '地铺矿洞', tier = 11 }
  tb1[8] = { zone = '地铺矿洞', tier = 4 }
  tb1[9] = { zone = '地铺矿洞', tier = 4 }
  tb1[10] = { zone = '地铺矿洞', tier = 4 }
  tb1[11] = { zone = '地铺矿洞', tier = 4 }
  tb1[12] = { zone = '地铺矿洞', tier = 4 }
  tb1[13] = { zone = '地铺矿洞', tier = 4 }





  table.insert(DRT_DB,
    { sort = "3", unitName = "AAA", classFilename = "HUNTER", show = "SHOW", realm = "贫瘠之地", record = tb1 })

  local tb2 = {}
  tb2[1] = { zone = '九号挖掘场', tier = 11 }
  tb2[2] = { zone = '塔克-雷桑深渊', tier = 8 }
  tb2[3] = { zone = '克莱格瓦之眠', tier = 8 }
  tb2[4] = { zone = '闸板陋巷', tier = 2 }
  tb2[5] = { zone = '幽暗要塞', tier = 11 }
  tb2[6] = { zone = '地铺矿洞', tier = 5 }
  tb2[7] = { zone = '地铺矿洞', tier = 11 }
  tb2[8] = { zone = '地铺矿洞', tier = 4 }
  tb2[9] = { zone = '地铺矿洞', tier = 4 }
  tb2[10] = { zone = '地铺矿洞', tier = 4 }
  tb2[11] = { zone = '地铺矿洞', tier = 4 }
  tb2[12] = { zone = '地铺矿洞', tier = 4 }
  tb2[13] = { zone = '地铺矿洞', tier = 4 }
  tb2[14] = { zone = '地铺矿洞', tier = 4 }
  tb2[15] = { zone = '地铺矿洞', tier = 4 }
  table.insert(DRT_DB,
    { sort = "22", unitName = "BBB", classFilename = "HUNTER", show = "SHOW", realm = "贫瘠之地", record = tb2 })

  for i = 1, 9 do
    table.insert(DRT_DB,
      { sort = "7", unitName = "CCC", classFilename = "HUNTER", show = "SHOW", realm = "贫瘠之地", record = tb1 })
  end

  local zs = DRT_DB['张三']
  if zs ~= nil then
    table.insert(DRT_DB,
      { sort = "5", unitName = "DDD", classFilename = "HUNTER", show = "SHOW", realm = "贫瘠之地", record = tb1 })
  end
  local ls = DRT_DB['李四']
  if ls ~= nil or ls ~= {} then
    table.insert(DRT_DB,
      { sort = "5", unitName = "EEE", classFilename = "MAGE", show = "SHOW", realm = "贫瘠之地", record = tb1 })
  end
end
