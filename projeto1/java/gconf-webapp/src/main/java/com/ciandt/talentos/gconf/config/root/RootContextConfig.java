package com.ciandt.talentos.gconf.config.root;


import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 *
 * The root context configuration of the application - the beans in this context will be globally visible
 * in all servlet contexts.
 *
 */

@Configuration
@ComponentScan({
	"com.ciandt.talentos.gconf.backend.services"
	})
public class RootContextConfig {


}
