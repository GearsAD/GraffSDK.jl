using Base.Test
using SynchronySDK

# TESTING
test = "{\"id\":\"NewUser\",\"name\":\"Bob Zacowski\",\"email\":\"email@email.com\",\"address\":\"N/A\",\"organization\":\"Student\",\"licenseType\":\"Student\",\"billingId\":\"96a3877e-738d-4c92-a880-98b0cbfd8937\",\"createdTimestamp\":\"2018-02-10T09:26:01.328\",\"lastUpdatedTimestamp\":\"2018-02-10T09:26:01.328\",\"links\":{\"robots\":\"/api/v0/users/NewUser/robots\",\"config\":\"/api/v0/users/NewUser/config\",\"self\":\"/api/v0/users/NewUser\"}}"
j = JSON.parse(test)
user = _unmarshallWithLinks(test, UserResponse)
@test JSON.json(user) == JSON.json(user)
