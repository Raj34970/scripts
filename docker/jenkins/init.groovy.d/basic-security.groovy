#!groovy

import jenkins.model.*
import hudson.security.*

def adminUsername = System.getenv("JENKINS_ADMIN_ID") ?: "admin"
def adminPassword = System.getenv("JENKINS_ADMIN_PASSWORD") ?: "admin"

def instance = Jenkins.getInstance()

if (instance.getSecurityRealm() instanceof HudsonPrivateSecurityRealm) {
    println "--> Creating local Jenkins admin user"

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount(adminUsername, adminPassword)
    instance.setSecurityRealm(hudsonRealm)

    def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
    strategy.setAllowAnonymousRead(false)
    instance.setAuthorizationStrategy(strategy)

    instance.save()
}
