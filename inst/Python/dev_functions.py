import ee


# productID = "JAXA/GPM_L3/GSMaP/v6/operational"
# productID = 'CGIAR/SRTM90_V4'
productID = "MODIS/051/MOD44B"




def get_info(productID):
    ee.Initialize()

    info_output = {}

    try:
        product = ee.Image(productID)
        info = product.getInfo()

        info_output['data_type'] = info['type']
        info_output['bands'] = product.bandNames().getInfo()
        info_output['epsg'] = info['bands'][0]['crs']

    except Exception:
        pass
    try:
        product_all = ee.ImageCollection(productID)
        product_single = ee.Image(product_all.first())
        info = product_single.getInfo()

        last = ee.Image(product_all.sort("system:time_start", False).first())
        first = ee.Image(product_all.sort("system:time_start").first())

        date_first = ee.Date(first.get('system:time_start')).format("Y-M-d").getInfo()
        date_last = ee.Date(last.get('system:time_start')).format("Y-M-d").getInfo()

        info_output['range'] = [date_first, date_last]

        info_output['size'] = product_all.size().getInfo()
        info_output['data_type'] = 'ImageCollection'
        info_output['bands'] = product_single.bandNames().getInfo()
        info_output['epsg'] = info['bands'][0]['crs']


    except Exception:
        raise IOError('With the given ID no data set was found')

    return info_output


info = get_info("LANDSAT/LC08/C01/T1_SR")


#print(data_type)
#print(info['bands'])

for key, value in info.items():
    print('the {} of the dataset are {}'.format(key, value))

#info_clean = json.loads(info)
# print(info_clean)


