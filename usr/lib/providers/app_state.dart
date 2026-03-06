import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _currentUser;
  
  // Mock data for demonstration
  final List&lt;String&gt; regions = [
    'Bengaluru',
    'Chennai',
    'Pune',
    'NCR',
    'Mumbai',
    'Hyderabad',
  ];
  
  final List&lt;Project&gt; _projects = [
    Project(id: '1', name: 'Project Alpha', region: 'Bengaluru'),
    Project(id: '2', name: 'Project Beta', region: 'Chennai'),
    Project(id: '3', name: 'Project Gamma', region: 'Pune'),
    Project(id: '4', name: 'Project Delta', region: 'NCR'),
  ];
  
  final List&lt;SPO&gt; _spos = [];
  final List&lt;COP&gt; _cops = [];
  final List&lt;Vendor&gt; _vendors = [
    Vendor(name: 'ABC Corp', poAmount: 10000.0),
    Vendor(name: 'XYZ Ltd', poAmount: 5000.0),
  ];

  bool get isLoggedIn =&gt; _isLoggedIn;
  String? get currentUser =&gt; _currentUser;
  List&lt;Project&gt; get projects =&gt; _projects;
  List&lt;SPO&gt; get spos =&gt; _spos;
  List&lt;COP&gt; get cops =&gt; _cops;
  List&lt;Vendor&gt; get vendors =&gt; _vendors;

  void login(String username, String password) {
    // Mock authentication
    if (username.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _currentUser = username;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void addSPO(SPO spo) {
    _spos.add(spo);
    notifyListeners();
  }

  void updateSPO(SPO updatedSPO) {
    final index = _spos.indexWhere((spo) =&gt; spo.id == updatedSPO.id);
    if (index != -1) {
      _spos[index] = updatedSPO;
      notifyListeners();
    }
  }

  void deleteSPO(String spoId) {
    _spos.removeWhere((spo) =&gt; spo.id == spoId);
    notifyListeners();
  }

  void addCOP(COP cop) {
    _cops.add(cop);
    notifyListeners();
  }

  void updateCOP(COP updatedCOP) {
    final index = _cops.indexWhere((cop) =&gt; cop.id == updatedCOP.id);
    if (index != -1) {
      _cops[index] = updatedCOP;
      notifyListeners();
    }
  }

  void deleteCOP(String copId) {
    _cops.removeWhere((cop) =&gt; cop.id == copId);
    notifyListeners();
  }

  List&lt;Project&gt; getProjectsByRegion(String region) {
    return _projects.where((project) =&gt; project.region == region).toList();
  }

  List&lt;SPO&gt; getSPObyProject(String projectId) {
    return _spos.where((spo) =&gt; spo.projectId == projectId).toList();
  }

  List&lt;COP&gt; getCOPbyProject(String projectId) {
    return _cops.where((cop) =&gt; cop.projectId == projectId).toList();
  }

  double getTotalBudgetUsed(String projectId) {
    return _cops
        .where((cop) =&gt; cop.projectId == projectId && cop.status == 'Approved')
        .fold(0.0, (sum, cop) =&gt; sum + cop.amount);
  }

  Map&lt;String, double&gt; getBudgetHeadUsage(String projectId) {
    Map&lt;String, double&gt; usage = {};
    for (var cop in _cops.where((cop) =&gt; cop.projectId == projectId && cop.status == 'Approved')) {
      usage[cop.budgetHead] = (usage[cop.budgetHead] ?? 0) + cop.amount;
    }
    return usage;
  }
}

class Project {
  final String id;
  final String name;
  final String region;
  final double totalBudget;
  final Map&lt;String, BudgetHead&gt; budgetHeads;

  Project({
    required this.id,
    required this.name,
    required this.region,
    this.totalBudget = 0.0,
    Map&lt;String, BudgetHead&gt;? budgetHeads,
  }) : budgetHeads = budgetHeads ?? {};
}

class BudgetHead {
  final String name;
  final double allocatedCost;
  double usedCost;
  double remainingCost;

  BudgetHead({
    required this.name,
    required this.allocatedCost,
    this.usedCost = 0.0,
  }) : remainingCost = allocatedCost - usedCost;

  void updateUsedCost(double newUsedCost) {
    usedCost = newUsedCost;
    remainingCost = allocatedCost - usedCost;
  }
}

class SPO {
  final String id;
  final String spoNumber;
  final String vendorName;
  final String projectId;
  final String region;
  final double amount;
  String status;
  final String? poNumber;
  final double? poAmount;
  final DateTime? approvedDate;

  SPO({
    required this.id,
    required this.spoNumber,
    required this.vendorName,
    required this.projectId,
    required this.region,
    required this.amount,
    this.status = 'Pending',
    this.poNumber,
    this.poAmount,
    this.approvedDate,
  });
}

class COP {
  final String id;
  final String copNumber;
  final String vendorName;
  final String projectId;
  final String region;
  final String budgetHead;
  final double amount;
  String status;

  COP({
    required this.id,
    required this.copNumber,
    required this.vendorName,
    required this.projectId,
    required this.region,
    required this.budgetHead,
    required this.amount,
    this.status = 'Pending',
  });
}

class Vendor {
  final String name;
  final double poAmount;

  Vendor({required this.name, required this.poAmount});
}