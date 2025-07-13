package Linksharing

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.stereotype.Component

@Component
@ConfigurationProperties(prefix = "mail")
class MailPluginConfiguration {
    String host
    int port
    String username
    String password
    String from
    boolean auth
    boolean starttls
}
