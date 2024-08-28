kubectl -n rook-ceph patch cephfilesystem.ceph.rook.io myfs -p '{"metadata":{"finalizers":null}}'
kubectl -n rook-ceph patch cephfilesystemsubvolumegroup.ceph.rook.io myfs-csi -p '{"metadata":{"finalizers":null}}'

kubectl -n rook-ceph delete -f rook/cluster.yaml
kubectl -n rook-ceph delete -f filesystem.yaml
kubectl -n rook-ceph delete -f rook/cluster.yaml

kubectl delete -f rook/common.yaml 
kubectl delete -f rook/operator-openshift.yaml

ssh $HOST3 "sudo rm -r -f  /var/lib/rook/*"
ssh $HOST2 "sudo rm -r -f  /var/lib/rook/*"
ssh $HOST1 "sudo rm -r -f  /var/lib/rook/*"

#danger!  make sure you wipe the correct disks
ssh $HOST3 "sudo wipefs -a /dev/sda"
ssh $HOST2 "sudo wipefs -a /dev/sdc"
ssh $HOST1 "sudo wipefs -a /dev/sdb"

kubectl delete ns rook-ceph
