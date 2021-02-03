-- Simple ping program to ensure the computers can ping each other
-- Client

os.loadAPI('apis/dnet.lua')

dnet.open('top')
print("Enter go when ready")
io.read()
print(dnet.frnPkg(dnet.p2p_sping(INSERT_PC_ID_HERE, 'mychannel')))
dnet.close()