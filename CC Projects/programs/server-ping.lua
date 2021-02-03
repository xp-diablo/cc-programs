-- Simple ping program to ensure the computers can ping each other
-- Server

os.loadAPI('apis/dnet.lua')

print("opening")
dnet.open('top')
print('listening...')
print(dnet.frnPkg(dnet.p2p_rping('mychannel')))
dnet.close()