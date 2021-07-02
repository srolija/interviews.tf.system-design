apps = {
  app1 = {
    image = "339751394740.dkr.ecr.eu-central-1.amazonaws.com/app1:latest"
    env = [
      {
        name  = "My"
        value = "Variable"
      }
    ]
  },
  app2 = {
    image = "339751394740.dkr.ecr.eu-central-1.amazonaws.com/app2:latest"
    env   = []
  },
  app3 = {
    image = "339751394740.dkr.ecr.eu-central-1.amazonaws.com/app3:latest"
    env   = []
  }
}