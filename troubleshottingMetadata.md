# curl -v http://169.254.169.254/openstack

### curl -s http://169.254.169.254/openstack/latest/meta_data.json | jq .| jq .
## OUtuput esperada
{
  "uuid": "4bfb20ac-c378-4eca-9ecb-321dd757918c",
  "public_keys": {
    "meme-key": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICj5Ibpg1ZBBaIL4YZI8vBTW4hOkpI2Bq9SmPKbkhaA8 manuel@manuel-hp\n"
  },
  "keys": [
    {
      "name": "meme-key",
      "type": "ssh",
      "data": "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICj5Ibpg1ZBBaIL4YZI8vBTW4hOkpI2Bq9SmPKbkhaA8 manuel@manuel-hp\n"
    }
  ],
  "hostname": "st-tesst-234-instance-fztr4zxfhnfn-inst1-uc35pojv3isf.openstacklocal",
  "name": "st-tesst-234-instance-fztr4zxfhnfn-inst1-uc35pojv3isf",
  "launch_index": 0,
  "availability_zone": "nova",
  "random_seed": "LT/2FeC+vPKGCYXeQIk7vtaF58shGXxr1HoY43Z9vPahHejggMalcCqRhyH0es3AdkfiIWJfZExRLIa6hx5oOT3/weKPWID3qhpenCPxcld2NtjWeb3BKa7VG29opv3OL1jloNtCh8OywarLFzpAqcJ9b4TPz2Ae8Pc5ABQxEqXatqihc6HzjIictvKfrS5RBG2vSqqPLcgw5dXW0CNuX75Kvo0RDe4boBXxdWXPpndPlbqGNQQbnWZGjP1S4KlNAtuAYXtEHAUVVpuS9hgHCMqUdouY7PPmyXubROHV9N0Yh2iMUAdGUM3rK8Y1NChGQgeSovXuW9ZkNNnWpt8Gt7nTYf4nh5YiVsgngDfBQySmIPtVZ4uDlw3QnpodoAMUpNG76ZKWWrtpU5VaUaSgRcvFrsqY3qRQoYekr6KAEUWATb/4Q45NOJtaolmmuw3CQj/dBaY60YxWySXM/sWb6CXehhLo6OICYCVYNNJSssejANfr+QUWc5dkit7YZA7YgjhA+1QaNLxJD7UbvLNTzqOEttSqzbhWHuNLAbRtl4DvQ3eYQZGl+r0Y1kVJ/DjmwpPNrqjpRupVLLR7+DjicZlDfADln79qEEQmg/5LofUBNxau93ZiX9OsTRIooc14iMWCEigNdaIG8a95GaumIiUf2nt5WwysBbHhOI/8fyY=",
  "project_id": "2b02c50e200b4de1a8a00c17f02cfc6e",
  "devices": [],
  "dedicated_cpus": []
}
ubuntu@test-instance-gpu:~$ 

