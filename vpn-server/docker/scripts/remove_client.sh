#========================================

export CLIENT_NAME="ccrayz"

# VPN User 제거
# revokeclient: Revoke a client certificate. This will also remove the client from the CRL.
docker compose run --rm openvpn ovpn_revokeclient $CLIENT_NAME remove

# CRL 생성
# CRL(Certificate Revocation List)은 인증서 폐기 목록으로, 인증서의 유효성을 확인하는데 사용
# CRL은 인증서를 폐기할 때 사용되며, 인증서가 유효하지 않다는 것을 나타냄
# CRL은 인증서의 유효기간이 만료되었거나, 개인키가 유출되었을 때 사용
docker compose run --rm openvpn easyrsa gen-crl

# VPN Server 재시작
docker compose restart openvpn