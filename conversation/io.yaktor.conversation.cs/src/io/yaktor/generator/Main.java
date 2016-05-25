/*
 * generated by Xtext
 */
package io.yaktor.generator;

import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.generator.GeneratorComponent;
import org.eclipse.xtext.generator.IFileSystemAccess;
import org.eclipse.xtext.generator.JavaIoFileSystemAccess;
import org.eclipse.xtext.util.CancelIndicator;
import org.eclipse.xtext.validation.CheckMode;
import org.eclipse.xtext.validation.IResourceValidator;
import org.eclipse.xtext.validation.Issue;

import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;

public class Main extends GeneratorComponent {

  public static void main(String[] args) {
    if (args.length == 0) {
      System.err.println("Aborting: no path to EMF resource provided!");
      return;
    }
    Injector injector = new io.yaktor.ConversationStandaloneSetup()
        .createInjectorAndDoEMFRegistration();
    Main main = injector.getInstance(Main.class);
    main.runGenerator(args);
  }

  @Inject
  private Provider<ResourceSet> resourceSetProvider;

  @Inject
  private IResourceValidator validator;

  @Inject
  private DomainGenerator domainGenerator;
  @Inject
  private ConversationGenerator conversationGenerator;
  @Inject
  private Injector injector;

  protected void runGenerator(String... strings) {
    // load the resource
    HashMap<String, Resource> m = new HashMap<String, Resource>();
    ResourceSet set = resourceSetProvider.get();
    setInjector(injector);
    // configure and start the generator
    IFileSystemAccess fileAccess = getConfiguredFileSystemAccess();

    System.out.println("Importing:");
    for (String string : strings) {
      Resource resource = m.containsKey(string)?m.get(string):set.getResource(URI.createURI(string),true);
      System.out.println(resource);
    }
    System.out.println("Validating:");
    for (Resource resource : set.getResources()) {
      System.out.println(resource.getURI());
      // validate the resource
      List<Issue> issues = validator.validate(resource,
          CheckMode.ALL, CancelIndicator.NullImpl);
      if (!issues.isEmpty()) {
        for (Issue issue : issues) {
          System.err.println(issue);
        }
      }
    }
    System.out.println("Generating:");
    for (Resource resource : set.getResources()) {
      System.out.println(resource.getURI());
      try {
        if (resource.getURI().fileExtension().matches("dm")) {
          domainGenerator.doGenerate(resource, fileAccess);
        } else {
          conversationGenerator.doGenerate(resource, fileAccess);
        }
      } catch (RuntimeException e) {
        System.out.println("Failed:" + resource.getURI());
        e.printStackTrace(System.err);
      }
    }

    System.out.println("Finished.");
  }
  protected IFileSystemAccess getConfiguredFileSystemAccess() {
    final JavaIoFileSystemAccess configuredFileSystemAccess = injector.getInstance(BetterFileSystemAccess.class);
    configuredFileSystemAccess.setOutputConfigurations(getOutputConfigurations());
    for (Entry<String, String> outs : getOutlets().entrySet()) {
        configuredFileSystemAccess.setOutputPath(outs.getKey(), outs.getValue());
    }
    return configuredFileSystemAccess;
  }
}